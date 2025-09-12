import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/route_card.dart';
import 'package:edwall_admin/features/groups/domain/lesson.dart';
import 'package:edwall_admin/core/widgets/route_view.dart';
import 'package:edwall_admin/features/lessons/domain/lessons.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LessonPage extends HookConsumerWidget {
  final int lessonId;

  const LessonPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedRouteState = useState<Route?>(null);
    final selectedRoute = selectedRouteState.value;

    return lesson.when(
      data: (programme) => Scaffold(
        floatingActionButton: selectedRoute == null
            ? FloatingActionButton(
                onPressed: () async {
                  final lessons = (await ref.read(lessonsProvider.future));
                  if (context.mounted) {
                    context.router.push(
                      LessonModifyRoute(
                        initial: programme,
                        newLessonOrder:
                            lessons.map((e) => e.order).fold(0, max) + 1,
                      ),
                    );
                  }
                },
                child: Icon(Icons.edit),
              )
            : null,
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
            IconButton.filled(
              onPressed: () => ref.invalidate(lessonProvider(lessonId)),
              icon: Icon(Icons.replay),
              color: colorScheme.onPrimary,
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
