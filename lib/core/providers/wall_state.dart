import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'wall_state.g.dart';

@Riverpod(keepAlive: true)
class WallState extends _$WallState {
  int _state = 0;

  @override
  Future<int> build(int bank, int led) async {
    final settings = await ref.watch(settingsProvider.future);
    if (settings.wallId < 0) {
      return 0;
    }
    return _state;
  }

  void _changeState(int newState) {
    if (_state != newState) {
      _state = newState;
      ref.invalidateSelf();
    }
  }

  void setLed(int newState) {
    ref.read(flashboardConnectionProvider.notifier).setLed(bank, led, newState);
    _changeState(newState);
  }

  Future<void> showRoute(RouteRead route, int startingModule) async {
    final activeWallId = (await ref.read(settingsProvider.future)).wallId;
    final activeWall = (await ref.read(wallProvider(activeWallId).future));
    final holdsPerModule = (activeWall.width / activeWall.numberOfModules)
        .round();

    // Clear modules
    final toBeCleared = activeWall.holds
        .where((element) {
          final int holdModule =
              ((element.numberInWall % activeWall.width) / holdsPerModule)
                  .floor();
          final ledHoldState = ref
              .read(wallStateProvider(element.bank, element.$num))
              .valueOrNull;
          return holdModule >= startingModule &&
              holdModule < startingModule + route.numberOfModules &&
              ledHoldState != null &&
              ledHoldState > 0;
        })
        .map((e) => (e.bank, e.$num))
        .toList();

    for (final hold in toBeCleared) {
      ref.read(wallStateProvider(hold.$1, hold.$2).notifier)._changeState(0);
    }
    final flashboardConnection = ref.read(
      flashboardConnectionProvider.notifier,
    );
    flashboardConnection.setLeds(toBeCleared, 0);

    final routeWithOffset = route.copyWith(
      holds: route.holds
          .map(
            (e) => e.copyWith(
              wallhold: activeWall.holds.firstWhere(
                (element) =>
                    element.numberInWall ==
                    e.wallhold.numberInWall + holdsPerModule * startingModule,
              ),
            ),
          )
          .toList(),
    );
    flashboardConnection.showRoute(routeWithOffset);
    for (final hold in routeWithOffset.holds) {
      ref
          .read(
            wallStateProvider(hold.wallhold.bank, hold.wallhold.$num).notifier,
          )
          ._changeState(hold.type);
    }
    ref.invalidateSelf();
  }

  void clear(WallRead wall) {
    ref.read(flashboardConnectionProvider.notifier).clear();
    for (final hold in wall.holds) {
      ref
          .read(wallStateProvider(hold.bank, hold.$num).notifier)
          ._changeState(0);
    }
  }
}
