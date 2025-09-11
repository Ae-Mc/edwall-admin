import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/hold_widget.dart';
import 'package:edwall_admin/features/sandbox/widgets/row_number_cell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveWallWidget extends StatelessWidget {
  final WallRead wall;
  final bool editable;

  const ActiveWallWidget({
    super.key,
    required this.wall,
    required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final holdsPerRoute = (wall.width / wall.numberOfModules).round();
        final height = constraints.maxHeight / (wall.height + 1);
        final size = height;
        final listItems = List<Widget>.generate(
          wall.width + 1,
          (x) => Column(
            children: List.generate(wall.height + 1, (y) {
              final isNumbersColumn = x == 0;
              final isNumbersRow = y == 0;
              final rowNumberCell = RowNumberCell(number: y, size: size);
              final columnNumberCell = Center(child: Text('$x'));
              late final Widget holdCell;

              if (!isNumbersColumn && !isNumbersRow) {
                final numberInWall = ((y - 1) * wall.width + x - 1);
                final hold = wall.holds.firstWhere(
                  (element) => element.numberInWall == numberInWall,
                );

                if (editable) {
                  holdCell = HoldWidget(hold: hold, size: size);
                } else {
                  holdCell = Consumer(
                    builder: (context, ref, child) {
                      return HoldWidget(
                        changeable: false,
                        initialState:
                            ref
                                .watch(wallStateProvider(hold.bank, hold.$num))
                                .valueOrNull ??
                            0,
                        hold: wall.holds.firstWhere(
                          (element) => element.numberInWall == numberInWall,
                        ),
                        size: size,
                      );
                    },
                  );
                }
              }

              return SizedBox.square(
                dimension: size,
                child: isNumbersColumn
                    ? (isNumbersRow ? null : rowNumberCell)
                    : (isNumbersRow ? columnNumberCell : holdCell),
              );
            }),
          ),
        );

        for (int i = wall.numberOfModules - 1; i > 0; i--) {
          listItems.insert(
            i * holdsPerRoute + 1,
            Column(
              children: [
                SizedBox(height: height),
                const Expanded(child: VerticalDivider()),
              ],
            ),
          );
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(listItems.length, (x) => listItems[x]),
        );
      },
    );
  }
}
