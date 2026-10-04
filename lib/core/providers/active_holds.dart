import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_holds.g.dart';

@Riverpod(keepAlive: true)
class ActiveHolds extends _$ActiveHolds {
  @override
  Future<List<(WallHoldReadWithHold, int)>> build() async {
    final settings = await ref.watch(settingsProvider.future);
    if (!ref.mounted) return const [];

    final wall = await ref.watch(wallProvider(settings.wallId).future);
    if (!ref.mounted) return const [];

    final colors = await Future.wait([
      for (final hold in wall.holds)
        ref.watch(wallStateProvider(hold.bank, hold.$num).future),
    ]);

    return [
      for (final (index, hold) in wall.holds.indexed)
        if (colors[index] != 0) (hold, colors[index]),
    ];
  }
}
