import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/widgets/default_app_bar.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/core/widgets/route_card.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:edwall_admin/features/programmes/domain/programmes.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

@RoutePage()
class ProgrammeModifyPage extends HookConsumerWidget {
  final int? programmeId;

  const ProgrammeModifyPage({super.key, this.programmeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insecure = useState(false);
    late final AsyncValue<ProgrammeRead?> programme;
    late final ProgrammeProvider? programmeProv;

    if (programmeId == null) {
      programmeProv = null;
      programme = AsyncValue.data(null);
    } else {
      programmeProv = programmeProvider(programmeId!);
      programme = ref.watch(programmeProv);
    }

    return programme.when(
      data: (initial) => HookBuilder(
        builder: (context) {
          final name = useTextEditingController(text: initial?.name ?? '');
          final description = useTextEditingController(
            text: initial?.description ?? '',
          );
          final level = useTextEditingController(
            text: initial?.level.toString() ?? '1',
          );
          final routes = useState<List<Route>>(initial?.routes ?? []);

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DefaultAppBar(
                    title: Text(
                      initial == null
                          ? 'Добавление раздела'
                          : 'Редактирование раздела',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: Pad(top: 8, left: 32, right: 48),
                  sliver: SliverList.list(
                    children: [
                      SizedBox(
                        height: 48 * 2 + 8 * 1,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return TableView(
                              delegate: TableCellListDelegate(
                                cells: [
                                  [
                                    TableViewCell(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Название раздела'),
                                      ),
                                    ),
                                    TableViewCell(
                                      child: TextField(
                                        controller: name,
                                        decoration: InputDecoration(
                                          hintText: 'Название раздела',
                                        ),
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  [
                                    TableViewCell(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Сложность'),
                                      ),
                                    ),
                                    TableViewCell(
                                      child: DropdownMenu(
                                        controller: level,
                                        enableSearch: false,
                                        width: double.infinity,
                                        initialSelection: initial?.level
                                            .toString(),
                                        inputDecorationTheme: theme
                                            .inputDecorationTheme
                                            .copyWith(
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                    maxWidth: 0,
                                                    maxHeight: 0,
                                                  ),
                                            ),
                                        menuStyle: MenuStyle(
                                          padding: WidgetStatePropertyAll(
                                            Pad.zero,
                                          ),
                                        ),
                                        onSelected: (i) =>
                                            level.text = i.toString(),
                                        inputFormatters: [
                                          TextInputFormatter.withFunction((
                                            oldValue,
                                            newValue,
                                          ) {
                                            final text = newValue.text;
                                            if (text.isEmpty) {
                                              return newValue;
                                            }
                                            final number = int.tryParse(text);
                                            if (number == null ||
                                                number < 1 ||
                                                number > 10) {
                                              return oldValue;
                                            }
                                            return newValue;
                                          }),
                                        ],
                                        textStyle: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                        dropdownMenuEntries: List.generate(
                                          10,
                                          (i) => DropdownMenuEntry(
                                            value: i + 1,
                                            label: "${i + 1}",
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                    theme.colorScheme.primary,
                                                  ),
                                              foregroundColor:
                                                  WidgetStatePropertyAll(
                                                    theme.colorScheme.onPrimary,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                                columnBuilder: (i) {
                                  final painter = TextPainter(
                                    text: TextSpan(
                                      text: "Название раздела",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  )..layout();
                                  final firstColWidth = painter.width;
                                  final leadingPaddings = <double>[0, 16];
                                  final flexibleExtents = [1];
                                  final widths = <double>[firstColWidth];
                                  final flexibleWidth =
                                      leadingPaddings.fold(
                                        widths.fold(
                                          constraints.maxWidth,
                                          (a, b) => a - b,
                                        ),
                                        (a, b) => a - b,
                                      ) /
                                      flexibleExtents.length;
                                  for (final index in flexibleExtents) {
                                    widths.insert(index, flexibleWidth);
                                  }
                                  return TableSpan(
                                    padding: SpanPadding(
                                      leading: leadingPaddings[i],
                                    ),
                                    extent: FixedSpanExtent(widths[i]),
                                  );
                                },
                                rowBuilder: (index) => TableSpan(
                                  extent: FixedSpanExtent(48),
                                  padding: SpanPadding(
                                    leading: (index == 0) ? 0 : 8,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Box.gap(32),
                      Text(
                        'Описание',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Box.gap(16),
                      TextField(
                        controller: description,
                        decoration: InputDecoration(
                          hintText: 'Описание раздела',
                        ),
                        maxLines: 5,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Box.gap(32),
                      Text(
                        'Список заданий',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Box.gap(16),
                      ...[
                        for (final route in routes.value) ...[
                          RouteCard(
                            route: route,
                            compact: true,
                            onDeleteTap: () {
                              routes.value = List.from(routes.value)
                                ..remove(route);
                            },
                          ),
                          Box.gap(16),
                        ],
                      ],
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: Pad(right: 48, left: 32, vertical: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (initial != null) ...[
                          Card(
                            child: Padding(
                              padding: const Pad(
                                top: 8,
                                horizontal: 12,
                                bottom: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ПОДТВЕРДИТЕ ДЕЙСТВИЕ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  Box.gap(16),
                                  SizedBox(
                                    width: 128,
                                    child:
                                        (insecure.value
                                        ? FutureButton.new
                                        : OutlinedButton.new)(
                                          onPressed: insecure.value
                                              ? () async {
                                                  await ref
                                                      .read(
                                                        programmesProvider()
                                                            .notifier,
                                                      )
                                                      .delete(initial.id);
                                                  if (context.mounted) {
                                                    context.router.pop();
                                                  }
                                                }
                                              : null,
                                          child: Text('УДАЛИТЬ'),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Box.gap(16),
                          IconButton(
                            onPressed: () => insecure.value = !insecure.value,
                            icon: Icon(
                              insecure.value
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                            ),
                            iconSize: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                        Expanded(child: Box()),
                        FutureButton(
                          onPressed: () async {
                            final programmes = ref.read(
                              programmesProvider().notifier,
                            );
                            if (initial != null) {
                              await programmes.modify(
                                initial.id,
                                ProgrammeUpdate(
                                  description: description.text,
                                  level: int.parse(level.text),
                                  name: name.text,
                                ),
                                routes.value.map((e) => e.id).toList(),
                              );
                            } else {
                              await programmes.add(
                                ProgrammeBase(
                                  description: description.text,
                                  level: int.parse(level.text),
                                  name: name.text,
                                ),
                                routes.value.map((e) => e.id).toList(),
                              );
                            }
                            if (context.mounted) {
                              context.router.pop();
                            }
                          },
                          buttonStyle: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(
                              Theme.of(
                                context,
                              ).textTheme.headlineMedium?.apply(color: null),
                            ),
                            padding: WidgetStatePropertyAll(
                              Pad(horizontal: 24, vertical: 16),
                            ),
                          ),
                          child: Text('СОХРАНИТЬ ИЗМЕНЕНИЯ'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ошибка загрузки данных раздела'),
            ElevatedButton(
              onPressed: () => (programmeProv == null)
                  ? null
                  : ref.invalidate(programmeProv),
              child: Text("Повторить попытку"),
            ),
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
