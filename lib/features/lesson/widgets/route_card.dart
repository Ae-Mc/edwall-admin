import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/lesson/widgets/square_button.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_grouped_table/flutter_grouped_table.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RouteCard extends HookWidget {
  final Route route;
  final void Function() onUpTap;
  final void Function() onDownTap;
  final void Function() onDeleteTap;

  const RouteCard({
    super.key,
    required this.onDeleteTap,
    required this.onUpTap,
    required this.onDownTap,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final expanded = useState(false);
    var shape =
        Theme.of(context).cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    if (shape is RoundedRectangleBorder && expanded.value) {
      shape = shape.copyWith(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Card(
      shape: shape,
      child: CardInnerInkwell(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: Pad(
            top: 4,
            bottom: expanded.value ? 12 : 4,
            left: 8,
            right: expanded.value ? 16 : 4,
          ),
          child: Table(
            columnWidths: {0: FlexColumnWidth(), 1: FixedColumnWidth(150)},
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          route.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (expanded.value) ...[
                          Box.gap(8),
                          Padding(
                            padding: const Pad(left: 16),
                            child: Text(
                              route.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          Box.gap(8),
                        ],
                      ],
                    ),
                  ),
                  if (expanded.value)
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.bottom,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GroupedTable(
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          borderRadius: BorderRadius.all(Radius.zero),
                          rowHeight: 43,
                          headerRows: [],
                          rowSpacing: 8,
                          dataRows: [
                            [
                              GroupedTableDataCell(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const Pad(left: 2),
                                  child: SquareButton(
                                    icon: Icons.keyboard_arrow_up,
                                    onPressed: onUpTap,
                                  ),
                                ),
                              ),
                              GroupedTableDataCell(
                                child: SquareButton(
                                  icon: Icons.keyboard_arrow_down,
                                  onPressed: onDownTap,
                                ),
                              ),
                              GroupedTableDataCell(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const Pad(right: 2),
                                  child: SquareButton(
                                    icon: Icons.delete_outline,
                                    onPressed: onDeleteTap,
                                  ),
                                ),
                              ),
                            ],
                            [
                              GroupedTableDataCell(
                                child: SizedBox.expand(
                                  child: FutureButton(
                                    onPressed: () async => {},
                                    child: Text("Просмотр"),
                                  ),
                                ),
                                colSpan: 3,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
