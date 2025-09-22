import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/providers/active_holds.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/features/routes/domain/current_route_edit_parameters.dart';
import 'package:edwall_admin/features/routes/widgets/save_route_dialog.dart';
import 'package:edwall_admin/features/sandbox/domain/hold_color.dart';
import 'package:edwall_admin/features/sandbox/widgets/active_wall_widget.dart';
import 'package:edwall_admin/core/widgets/bluetooth_button.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/features/sandbox/widgets/color_preview.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SandboxPage extends ConsumerWidget {
  const SandboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(holdColorProvider);
    final settings = ref.watch(settingsProvider);
    AsyncValue<WallRead> wall = ref.watch(
      wallProvider(settings.requireValue.wallId),
    );

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Песочница"),
          leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed:
                  ref.watch(activeHoldsProvider).value?.isNotEmpty == true
                  ? () => showDialog(
                      context: context,
                      builder: (context) => SaveRouteDialog(),
                    )
                  : null,
              icon: Icon(Icons.save),
              color: Theme.of(context).colorScheme.primary,
              tooltip: 'Сохранение трассы',
            ),
            PopupMenuButton<int>(
              initialValue: color,
              onSelected: (value) =>
                  ref.read(holdColorProvider.notifier).set(value),
              itemBuilder: (context) => holdTypeToColor.keys
                  .skip(1)
                  .map<PopupMenuItem<int>>(
                    (value) => PopupMenuItem(
                      value: value,
                      child: ColorPreview(colorCode: value, size: 24),
                    ),
                  )
                  .toList(),
              child: Padding(
                padding: const Pad(all: 8),
                child: ColorPreview(colorCode: color, size: 24),
              ),
            ),
            Builder(
              builder: (context) {
                if (wall.value == null) {
                  return const SizedBox();
                }
                return IconButton(
                  onPressed: () {
                    ref
                        .read(wallStateProvider(1, 1).notifier)
                        .clear(wall.value!);
                    ref
                        .read(currentRouteEditParametersProvider.notifier)
                        .clear();
                  },
                  icon: const Icon(Icons.replay),
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: "Сбросить выделение",
                );
              },
            ),
            const BluetoothButton(),
          ],
        ),
        body: wall.when(
          data: (wall) => ActiveWallWidget(wall: wall, editable: true),
          error: (error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorText(error: error),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(
                    wallProvider(settings.requireValue.wallId),
                  ),
                  child: const Text("Повторить попытку"),
                ),
              ],
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
