import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/providers/active_holds.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/routes/domain/current_route_edit_parameters.dart';
import 'package:edwall_admin/features/routes/domain/routes.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SaveRouteDialog extends HookConsumerWidget {
  const SaveRouteDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final asNew = useState<bool>(
      ref.read(currentRouteEditParametersProvider).id == null,
    );
    final params = ref.watch(currentRouteEditParametersProvider);
    useListenable(params.name);
    useListenable(params.difficulty);

    return Dialog(
      child: Container(
        padding: const Pad(all: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Сохранение трассы', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Название', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: params.name,
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              const SizedBox(height: 8),
              DropdownMenu<int>(
                controller: params.difficulty,
                enableSearch: false,
                width: double.infinity,
                inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                  suffixIconConstraints: BoxConstraints(
                    maxWidth: 0,
                    maxHeight: 0,
                  ),
                ),
                menuStyle: MenuStyle(padding: WidgetStatePropertyAll(Pad.zero)),
                onSelected: (i) => params.difficulty.text =
                    i?.toString() ?? params.difficulty.text,
                textStyle: TextStyle(color: theme.colorScheme.onPrimary),
                dropdownMenuEntries: List.generate(
                  12,
                  (i) => DropdownMenuEntry(
                    value: i + 1,
                    label: "${i + 1}",
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        theme.colorScheme.primary,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Описание', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: params.description,
                maxLines: 5,
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              CheckboxListTile(
                title: const Text("Сохранить как новую трассу"),
                value: asNew.value,
                onChanged: (value) => asNew.value = value ?? false,
                enabled:
                    ref.watch(currentRouteEditParametersProvider).id != null,
              ),
              const SizedBox(height: 16),
              FutureButton(
                onPressed:
                    params.name.text.trim() == '' ||
                        int.tryParse(params.difficulty.text) == null
                    ? null
                    : () async {
                        if (asNew.value) {
                          ref
                              .read(currentRouteEditParametersProvider.notifier)
                              .setRouteId(null);
                        }
                        await saveRoute(
                          ref: ref,
                          context: context,
                          params: ref.read(currentRouteEditParametersProvider),
                        );
                      },
                child: const Text("Сохранить"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveRoute({
    required WidgetRef ref,
    required BuildContext context,
    required RouteEditParameters params,
  }) async {
    final settings = await ref.read(settingsProvider.future);
    final wall = await ref.read(wallProvider(settings.wallId).future);
    final holds = await ref.read(activeHoldsProvider.future);
    final holdsPerModule = (wall.width / wall.numberOfModules).round();
    final maxHoldX = holds
        .map((e) => e.$1.numberInWall % wall.width)
        .fold(0, max);
    final numberOfModules = (maxHoldX / holdsPerModule + 1).floor();

    if (params.id != null) {
      await ref
          .read(routesProvider().notifier)
          .modify(
            params.id!,
            RouteUpdate(
              description: params.description.text,
              difficult: params.difficulty.toString(),
              name: params.name.text,
              numberOfModules: numberOfModules,
            ),
            holds.map((e) => (e.$1.id, e.$2)).toList(),
          );
    } else {
      final route = await ref
          .read(routesProvider().notifier)
          .add(
            RouteBase(
              description: params.description.text,
              difficult: params.difficulty.text,
              name: params.name.text,
              numberOfModules: numberOfModules,
            ),
            holds.map((e) => (e.$1.id, e.$2)).toList(),
          );
      ref
          .read(currentRouteEditParametersProvider.notifier)
          .setRouteId(route.id);
    }
    if (context.mounted) {
      context.router.pop();
    }
  }

  void overwrite(BuildContext context, WidgetRef ref) async {}
}
