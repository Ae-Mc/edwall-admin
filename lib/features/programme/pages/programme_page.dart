import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/route_card.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:edwall_admin/core/widgets/route_view.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ProgrammePage extends HookConsumerWidget {
  final int programmeId;

  const ProgrammePage({super.key, required this.programmeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programme = ref.watch(programmeProvider(programmeId));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedRouteState = useState<Route?>(null);
    final selectedRoute = selectedRouteState.value;

    return programme.when(
      data: (programme) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => AutoRouter.of(
            context,
          ).push(ProgrammeModifyRoute(initial: programme)),
          child: Icon(Icons.edit),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(title: Text(programme.name)),
                  ],
                  body: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const Pad(horizontal: 16),
                        sliver: SliverList.list(
                          children: [
                            Text('Описание', style: textTheme.titleMedium),
                            Text(programme.description, maxLines: 30),
                            Text('Сложность', style: textTheme.titleMedium),
                            Row(
                              children: List.filled(
                                programme.level,
                                Container(
                                  margin: const Pad(right: 8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const Pad(horizontal: 16),
                        sliver: SliverList.separated(
                          itemBuilder: (context, index) => RouteCard(
                            route: programme.routes[index],
                            selected: selectedRoute == programme.routes[index],
                            compact: selectedRoute != null,
                            onTap: () =>
                                selectedRoute == programme.routes[index]
                                ? selectedRouteState.value = null
                                : selectedRouteState.value =
                                      programme.routes[index],
                          ),
                          itemCount: programme.routes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                      ),
                    ],
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
                Expanded(flex: 3, child: RouteView(selectedRoute)),
              ],
            ],
          ),
        ),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ошибка: ${error.toString()}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
