import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/route_card.dart';
import 'package:edwall_admin/features/routes/domain/routes.dart';
import 'package:edwall_admin/features/routes/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class RouteSelectPage extends HookConsumerWidget {
  final List<int> excludeIds;

  const RouteSelectPage({super.key, this.excludeIds = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final numberOfModulesFrom = useState<int?>(null);
    final numberOfModulesTo = useState<int?>(null);
    final nameContains = useState<String?>(null);

    final provider = routesProvider(
      nameContains: nameContains.value,
      numberOfModulesFrom: numberOfModulesFrom.value,
      numberOfModulesTo: numberOfModulesTo.value,
    );
    final routes = ref.watch(provider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      ),
      body: Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              AppBar(title: Text("Выбор задания")),
              Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
            ],
          ),
          Expanded(
            child: HookConsumer(
              builder: (context, ref, child) {
                return routes.when(
                  data: (data) {
                    data = data
                        .where((element) => !excludeIds.contains(element.id))
                        .toList();
                    data.sort((a, b) => a.name.compareTo(b.name));
                    return RefreshIndicator.adaptive(
                      onRefresh: () => onRefresh(ref, provider),
                      child: ListView.separated(
                        padding: Pad(left: 32, right: 48, top: 8),
                        itemCount: data.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemBuilder: (context, index) => RouteCard(
                          route: data[index],
                          onTap: () async => context.router.pop(data[index]),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => RefreshIndicator.adaptive(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              "Ошибка: $error",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onRefresh: () => onRefresh(ref, provider),
                  ),
                  loading: () =>
                      Center(child: CircularProgressIndicator.adaptive()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onRefresh(WidgetRef ref, RoutesProvider provider) async {
    ref.invalidate(provider);
    await ref.read(provider.future);
  }
}
