import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_holds.g.dart';

@riverpod
class ActiveHolds extends _$ActiveHolds {
  @override
  Future<List<(WallHoldReadWithHold, int)>> build() async {
    final settings = await ref.watch(settingsProvider.future);
    final wall = await ref.watch(wallProvider(settings.wallId).future);
    final result = <(WallHoldReadWithHold, int)>[];
    for (final hold in wall.holds) {
      final color = await ref.watch(
        wallStateProvider(hold.bank, hold.$num).future,
      );
      if (color != 0) {
        result.add((hold, color));
      }
    }
    return result;
  }
}
