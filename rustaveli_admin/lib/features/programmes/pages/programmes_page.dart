import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/features/programmes/domain/programmes.dart';
import 'package:edwall_admin/features/programmes/widgets/bottom_sheet.dart';
import 'package:edwall_admin/features/programmes/widgets/programme_card.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ProgrammesPage extends HookConsumerWidget {
  const ProgrammesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelFrom = useState<int?>(null);
    final levelTo = useState<int?>(null);
    final nameContains = useState<String?>(null);
    final provider = programmesProvider(
      levelFrom: levelFrom.value,
      levelTo: levelTo.value,
      nameContains: nameContains.value,
    );
    final AsyncValue<List<Programme>> programmes = ref.watch(provider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "programmesPageFloating",
        onPressed: () async {
          final result = await showModalBottomSheet<Filter>(
            context: context,
            isScrollControlled: true,
            builder: (context) => BottomSheet(
              initialLevelFrom: levelFrom.value,
              initialLevelTo: levelTo.value,
              initialNameContains: nameContains.value,
            ),
          );

          if (result != null) {
            levelFrom.value = result.levelFrom;
            levelTo.value = result.levelTo;
            nameContains.value = result.nameContains;
          }
        },
        child: const Icon(Icons.filter_list),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => const [
              SliverAppBar(title: Text("Программы")),
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(provider);
                await ref.read(provider.future);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const Pad(all: 16),
                    sliver: programmes.when(
                      data: (programmes) => programmes.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  "Программы не найдены",
                                  style: textTheme.labelLarge,
                                ),
                              ),
                            )
                          : SliverList.separated(
                              itemBuilder: (context, index) =>
                                  ProgrammeCard(programme: programmes[index]),
                              itemCount: programmes.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                            ),
                      error: (error, _) =>
                          SliverToBoxAdapter(child: ErrorText(error: error)),
                      loading: () => const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const Pad(bottom: 16),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              context.router.push(ProgrammeModifyRoute()),
                          child: const Text("Добавить программу"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
