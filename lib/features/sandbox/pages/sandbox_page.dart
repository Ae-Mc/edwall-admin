import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/features/sandbox/domain/hold_color.dart';
import 'package:edwall_admin/features/sandbox/widgets/active_wall_widget.dart';
import 'package:edwall_admin/core/widgets/bluetooth_button.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/features/sandbox/widgets/color_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SandboxPage extends StatelessWidget {
  const SandboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Песочница"),
          leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                final color = ref.watch(holdColorProvider);

                return PopupMenuButton<int>(
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
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final settings = ref.watch(settingsProvider).valueOrNull;
                if (settings == null) {
                  return const SizedBox();
                }
                final wall = ref
                    .watch(wallProvider(settings.wallId))
                    .valueOrNull;
                if (wall == null) {
                  return const SizedBox();
                }
                return IconButton(
                  onPressed: () =>
                      ref.read(wallStateProvider(1, 1).notifier).clear(wall),
                  icon: const Icon(Icons.replay),
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: "Сбросить выделение",
                );
              },
            ),
            const BluetoothButton(),
          ],
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final settings = ref.watch(settingsProvider).requireValue;
            final wall = ref.watch(wallProvider(settings.wallId));

            return wall.when(
              data: (wall) => ActiveWallWidget(wall: wall, editable: true),
              error: (error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorText(error: error),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(wallProvider(settings.wallId)),
                      child: const Text("Повторить попытку"),
                    ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
            );
          },
        ),
      ),
    );
  }
}
