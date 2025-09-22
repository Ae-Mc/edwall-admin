import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/groups/domain/study_groups.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

@RoutePage()
class GroupModifyPage extends StatefulWidget {
  final StudyGroupRead? initialGroup;

  const GroupModifyPage({super.key, required this.initialGroup});

  @override
  State<GroupModifyPage> createState() => _GroupModifyPageState();
}

class _GroupModifyPageState extends State<GroupModifyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classTeacherController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _studentsCountController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _studyPlanController = TextEditingController();

  StudyPlan? selectedStudyPlan;
  bool insecure = false;

  @override
  void initState() {
    _nameController.text = widget.initialGroup?.name ?? '';
    _classTeacherController.text = widget.initialGroup?.classTeacher ?? '';
    _studentsCountController.text =
        widget.initialGroup?.studentsCount.toString() ?? '';
    _descriptionController.text = widget.initialGroup?.description ?? '';
    _studyPlanController.text = widget.initialGroup?.studyPlan.name ?? '';
    selectedStudyPlan = widget.initialGroup?.studyPlan;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('ДАННЫЕ О ГРУППЕ'),
                  titleSpacing: 30,
                  leading: Center(
                    child: SizedBox.square(
                      dimension: 45,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size.zero),
                          padding: WidgetStatePropertyAll(Pad.zero),
                        ),
                        child: Icon(Icons.arrow_back_rounded, size: 32),
                        onPressed: () => context.maybePop(),
                      ),
                    ),
                  ),
                ),
                Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
              ],
            ),
          ),
          SliverPadding(
            padding: Pad(top: 8, left: 32, right: 48),
            sliver: SliverList.list(
              children: [
                SizedBox(
                  height: 48 * 4 + 8 * 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return TableView(
                        delegate: TableCellListDelegate(
                          cells: [
                            [
                              TableViewCell(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Название группы'),
                                ),
                              ),
                              TableViewCell(
                                columnMergeStart: 1,
                                columnMergeSpan: 4,
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Название группы',
                                  ),
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(child: SizedBox()),
                            ],
                            [
                              TableViewCell(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Год обучения'),
                                ),
                              ),
                              TableViewCell(
                                child: DropdownMenu(
                                  controller: _yearController,
                                  enableSearch: false,
                                  width: double.infinity,
                                  initialSelection:
                                      widget.initialGroup?.studyingYear,
                                  inputDecorationTheme: theme
                                      .inputDecorationTheme
                                      .copyWith(
                                        suffixIconConstraints: BoxConstraints(
                                          maxWidth: 0,
                                          maxHeight: 0,
                                        ),
                                      ),
                                  menuStyle: MenuStyle(
                                    padding: WidgetStatePropertyAll(Pad.zero),
                                  ),
                                  onSelected: (i) =>
                                      _yearController.text = "$iй год",
                                  textStyle: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                  dropdownMenuEntries: List.generate(
                                    12,
                                    (i) => DropdownMenuEntry(
                                      value: i + 1,
                                      label: "${i + 1}й год",
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
                              ),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(child: SizedBox()),
                            ],
                            [
                              TableViewCell(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Учебный план'),
                                ),
                              ),
                              TableViewCell(
                                child: TextField(
                                  controller: _studyPlanController,
                                  decoration: InputDecoration(
                                    hintText: 'Учебный план',
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  readOnly: true,
                                  onTap: () {
                                    context
                                        .pushRoute<StudyPlan?>(
                                          StudyPlanSelectRoute(),
                                        )
                                        .then((value) {
                                          if (value == null) {
                                            return;
                                          }
                                          _studyPlanController.text =
                                              value.name;
                                          setState(() {
                                            selectedStudyPlan = value;
                                          });
                                        });
                                  },
                                ),
                              ),
                              TableViewCell(
                                child: OutlinedButton(
                                  onPressed: () => context
                                      .pushRoute<StudyPlan?>(
                                        StudyPlanSelectRoute(),
                                      )
                                      .then((value) {
                                        if (value != null) {
                                          selectedStudyPlan = value;
                                          _studyPlanController.text =
                                              value.name;
                                        }
                                      }),
                                  child: Text('ВЫБРАТЬ'),
                                ),
                              ),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(child: SizedBox()),
                            ],
                            [
                              TableViewCell(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Классный руководитель'),
                                ),
                              ),
                              TableViewCell(
                                child: TextField(
                                  controller: _classTeacherController,
                                  decoration: InputDecoration(hintText: 'ФИО'),
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              TableViewCell(child: SizedBox()),
                              TableViewCell(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('Количество учеников'),
                                ),
                              ),
                              TableViewCell(
                                child: TextField(
                                  controller: _studentsCountController,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'\d'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                          columnBuilder: (i) {
                            final painter = TextPainter(
                              text: TextSpan(
                                text: "Классный руководитель",
                                style: theme.textTheme.bodyMedium,
                              ),
                              textDirection: TextDirection.ltr,
                            )..layout();
                            final firstColWidth = painter.width;
                            final fourthColWidth = (TextPainter(
                              text: TextSpan(
                                text: "Количество учеников",
                                style: theme.textTheme.bodyMedium,
                              ),
                              textDirection: TextDirection.ltr,
                            )..layout()).width;

                            final leadingPaddings = <double>[0, 16, 16, 32, 16];
                            final flexibleExtents = [1];
                            final widths = <double>[
                              firstColWidth,
                              96,
                              fourthColWidth,
                              92,
                            ];
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
                              padding: SpanPadding(leading: leadingPaddings[i]),
                              extent: FixedSpanExtent(widths[i]),
                            );
                          },
                          rowBuilder: (index) => TableSpan(
                            extent: FixedSpanExtent(48),
                            padding: SpanPadding(leading: (index == 0) ? 0 : 8),
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
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: 'Описание группы'),
                  maxLines: 5,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
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
                  if (widget.initialGroup != null) ...[
                    Card(
                      child: Padding(
                        padding: const Pad(top: 8, horizontal: 12, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ПОДТВЕРДИТЕ ДЕЙСТВИЕ',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Box.gap(16),
                            Row(
                              children: [
                                SizedBox(
                                  width: 128,
                                  child: Consumer(
                                    builder: (context, ref, child) =>
                                        (insecure
                                        ? ElevatedButton.new
                                        : OutlinedButton.new)(
                                          onPressed: insecure
                                              ? () async {
                                                  await ref
                                                      .read(
                                                        myStudyGroupsProvider
                                                            .notifier,
                                                      )
                                                      .updateGroup(
                                                        widget.initialGroup!.id,
                                                        StudyGroupUpdate(
                                                          archived: true,
                                                        ),
                                                      );
                                                  if (context.mounted) {
                                                    context.maybePop();
                                                  }
                                                }
                                              : null,
                                          child: Text('В АРХИВ'),
                                        ),
                                  ),
                                ),
                                Box.gap(32),
                                SizedBox(
                                  width: 128,
                                  child:
                                      (insecure
                                      ? ElevatedButton.new
                                      : OutlinedButton.new)(
                                        onPressed: insecure ? () {} : null,
                                        child: Text('УДАЛИТЬ'),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Box.gap(16),
                    IconButton(
                      onPressed: () => setState(() => insecure = !insecure),
                      icon: Icon(
                        insecure
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline,
                      ),
                      iconSize: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                  Expanded(child: Box()),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                          return FutureButton(
                            onPressed: () => onSave(ref),
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
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectStudyPlan(
    BuildContext context,
    TextEditingController studyPlanController,
    ValueNotifier<StudyPlan?> studyPlan,
  ) {
    context.pushRoute<StudyPlan?>(StudyPlanSelectRoute()).then((value) {
      if (value == null) {
        return;
      }
      studyPlanController.text = value.name;
      studyPlan.value = value;
    });
  }

  Future<void> onSave(WidgetRef ref) async {
    final yearRaw = _yearController.text;
    final year = int.tryParse(
      yearRaw.substring(0, yearRaw.lastIndexOf(RegExp(r'\d')) + 1),
    );
    final studentsCount = int.tryParse(_studentsCountController.text);
    final toast = CustomToast(ref.context);

    try {
      if (widget.initialGroup != null) {
        final groupUpdate = StudyGroupUpdate(
          name: _nameController.text,
          classTeacher: _classTeacherController.text,
          description: _descriptionController.text,
          studyPlanId: selectedStudyPlan?.id,
          studentsCount: studentsCount,
          studyingYear: year,
        );
        await ref
            .read(myStudyGroupsProvider.notifier)
            .updateGroup(widget.initialGroup!.id, groupUpdate);
        toast.showTextSuccessToast('Группа успешно изменена!');
        if (ref.context.mounted) {
          ref.context.maybePop();
        }
      } else {
        if (selectedStudyPlan == null) {
          toast.showTextFailureToast('Выберите учебный план!');
          return;
        }
        if (studentsCount == null) {
          toast.showTextFailureToast('Введите количество учеников в группе!');
          return;
        }

        final groupCreate = StudyGroupBaseExtended(
          name: _nameController.text,
          classTeacher: _classTeacherController.text,
          description: _descriptionController.text,
          studyPlanId: selectedStudyPlan!.id,
          studentsCount: studentsCount,
          studyingYear: year,
        );
        await ref
            .read(myStudyGroupsProvider.notifier)
            .createStudyGroup(groupCreate);
        toast.showTextSuccessToast('Группа успешно создана!');
        if (ref.context.mounted) {
          AutoRouter.of(
            ref.context,
          ).popUntilRouteWithName(GroupSelectRoute.name);
        }
      }
    } catch (e) {
      if (ref.context.mounted) {
        switch (e) {
          case ExceptionWithMessage(message: final message):
            toast.showTextFailureToast(message);
            break;
          default:
            toast.showTextFailureToast('Неизвестная ошибка: $e');
        }
      }
    }
  }
}
