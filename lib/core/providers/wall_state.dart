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

  int? _readHoldState(int holdBank, int holdLed) {
    if (holdBank == bank && holdLed == led) {
      return _state;
    }
    return ref.read(wallStateProvider(holdBank, holdLed)).value;
  }

  void _changeHoldState(int holdBank, int holdLed, int newState) {
    if (holdBank == bank && holdLed == led) {
      _changeState(newState);
      return;
    }
    ref
        .read(wallStateProvider(holdBank, holdLed).notifier)
        ._changeState(newState);
  }

  Future<void> setLed(int newState) async {
    await ref
        .read(flashboardConnectionProvider.notifier)
        .setLed(bank, led, newState);
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
          final ledHoldState = _readHoldState(element.bank, element.$num);
          return holdModule >= startingModule &&
              holdModule < startingModule + route.numberOfModules &&
              ledHoldState != null &&
              ledHoldState > 0;
        })
        .map((e) => (e.bank, e.$num))
        .toList();

    for (final hold in toBeCleared) {
      _changeHoldState(hold.$1, hold.$2, 0);
    }
    final flashboardConnection = ref.read(
      flashboardConnectionProvider.notifier,
    );
    await flashboardConnection.setLeds(toBeCleared, 0);

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
    await flashboardConnection.showRoute(routeWithOffset);
    for (final hold in routeWithOffset.holds) {
      _changeHoldState(hold.wallhold.bank, hold.wallhold.$num, hold.type);
    }
    ref.invalidateSelf();
  }

  Future<void> clear(WallRead wall) async {
    await ref.read(flashboardConnectionProvider.notifier).clear();
    for (final hold in wall.holds) {
      _changeHoldState(hold.bank, hold.$num, 0);
    }
  }
}
