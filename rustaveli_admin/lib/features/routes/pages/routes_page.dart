import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/core/widgets/route_card.dart';
import 'package:edwall_admin/core/widgets/route_view.dart';
import 'package:edwall_admin/features/routes/domain/routes.dart';
import 'package:edwall_admin/features/routes/widgets/bottom_sheet.dart';
import 'package:edwall_admin/features/routes/widgets/confirmation_dialog.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route, BottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class RoutesPage extends HookConsumerWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRouteState = useState<Route?>(null);
    final selectedRoute = selectedRouteState.value;
    final numberOfModulesFrom = useState<int?>(null);
    final numberOfModulesTo = useState<int?>(null);
    final nameContains = useState<String?>(null);
    final compact = useState<bool>(false);

    final provider = routesProvider(
      nameContains: nameContains.value,
      numberOfModulesFrom: numberOfModulesFrom.value,
      numberOfModulesTo: numberOfModulesTo.value,
    );
    final routes = ref.watch(provider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: selectedRoute == null
          ? FloatingActionButton(
              heroTag: "routesPageFloating",
              onPressed: () async {
                final result = await showModalBottomSheet<Filter>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BottomSheet(
                    initialNumberOfModulesFrom: numberOfModulesFrom.value,
                    initialNumberOfModulesTo: numberOfModulesTo.value,
                    initialNameContains: nameContains.value,
                  ),
                );

                if (result != null) {
                  numberOfModulesFrom.value = result.numberOfModulesFrom;
                  numberOfModulesTo.value = result.numberOfModulesTo;
                  nameContains.value = result.nameContains;
                }
              },
              child: const Icon(Icons.filter_list),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: const Text("Задания"),
                    actions: selectedRoute == null
                        ? [
                            Padding(
                              padding: const Pad(right: 16),
                              child: ToggleButtons(
                                constraints: const BoxConstraints(minHeight: 0),
                                borderRadius: BorderRadius.circular(100),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                isSelected: [!compact.value, compact.value],
                                onPressed: (index) =>
                                    compact.value = index == 1,
                                children: const [
                                  Padding(
                                    padding: Pad(all: 4),
                                    child: Text('Подробно'),
                                  ),
                                  Padding(
                                    padding: Pad(all: 4),
                                    child: Text('Кратко'),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        : null,
                  ),
                ],
                body: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(provider);
                    await ref.read(provider.future);
                  },
                  child: CustomScrollView(
                    slivers: [
                      routes.when(
                        data: (routes) => SliverPadding(
                          padding: const Pad(all: 16),
                          sliver: routes.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(
                                      "Задания не найдены",
                                      style: textTheme.labelLarge,
                                    ),
                                  ),
                                )
                              : SliverList.separated(
                                  itemBuilder: (context, index) => RouteCard(
                                    route: routes[index],
                                    compact:
                                        compact.value || selectedRoute != null,
                                    selected: selectedRoute == routes[index],
                                    onTap: () => selectedRoute == routes[index]
                                        ? selectedRouteState.value = null
                                        : selectedRouteState.value =
                                              routes[index],
                                  ),
                                  itemCount: routes.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                ),
                        ),
                        error: (error, _) => SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [ErrorText(error: error)],
                            ),
                          ),
                        ),
                        loading: () => const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedRoute != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(2),
                ),
                width: 2,
                height: double.infinity,
              ),
              Expanded(
                flex: 3,
                child: RouteView(
                  selectedRoute,
                  onDeletePressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: "Удаление задания",
                        content:
                            "Вы уверены, что хотите удалить это задание? Это действие необратимо.",
                      ),
                    );

                    if (confirmed != true) {
                      return;
                    }

                    try {
                      await ref
                          .read(routesProvider().notifier)
                          .delete(selectedRoute.id);
                      selectedRouteState.value = null;
                      toastification.show(
                        autoCloseDuration: Duration(seconds: 3),
                        style: ToastificationStyle.minimal,
                        type: ToastificationType.success,
                        title: Text("Задание успешно удалено"),
                      );
                    } catch (e) {
                      if (context.mounted) {
                        Logger().e("Error deleting route", error: e);
                        toastification.show(
                          type: ToastificationType.error,
                          title: Text("Ошибка при удалении задания"),
                          description: Text(e.toString()),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
