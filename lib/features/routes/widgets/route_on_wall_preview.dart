import 'dart:math';

import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/hold_widget.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteOnWallPreview extends StatelessWidget {
  final RouteRead route;
  final WallRead wall;
  final int? startingModule;
  final void Function(int moduleNumber) onStartingModuleSelect;

  static const _moduleBorderWidth = 1.0;
  final int _widthPerModule;
  final int? _lastSelectedModule;

  RouteOnWallPreview({
    super.key,
    required this.route,
    required this.wall,
    this.startingModule,
    required this.onStartingModuleSelect,
  }) : _widthPerModule = (wall.width / wall.numberOfModules).round(),
       _lastSelectedModule = startingModule == null
           ? null
           : min(
               route.numberOfModules + startingModule - 1,
               wall.numberOfModules - 1,
             );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size =
            (constraints.maxHeight - _moduleBorderWidth * 2) / wall.height;

        final listItems = List<Widget>.generate(
          wall.numberOfModules,
          (moduleNumber) => module(context, size, moduleNumber),
        );

        return ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(listItems.length, (x) => listItems[x]),
        );
      },
    );
  }

  bool isSelected(int moduleNumber) {
    return _lastSelectedModule == null
        ? false
        : (moduleNumber >= startingModule! &&
              moduleNumber <= _lastSelectedModule);
  }

  Color getSelectionColor(BuildContext context) =>
      ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        4,
      );

  bool isSelectable(int moduleNumber) =>
      wall.numberOfModules - moduleNumber >= route.numberOfModules;

  Widget module(BuildContext context, double size, int moduleNumber) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: _moduleBorderWidth,
            color: isSelected(moduleNumber)
                ? colorScheme.primary
                : colorScheme.onSurface,
          ),
        ),
      ),
      child: Material(
        color: isSelected(moduleNumber) ? getSelectionColor(context) : null,
        child: InkWell(
          onTap: isSelectable(moduleNumber)
              ? () => onStartingModuleSelect(moduleNumber)
              : null,
          child: Row(
            children: List.generate(
              _widthPerModule,
              (x) => Column(
                children: List.generate(wall.height, (y) {
                  final numberInWall =
                      y * wall.width + x + moduleNumber * _widthPerModule;
                  final hold = wall.holds.firstWhere(
                    (element) => element.numberInWall == numberInWall,
                  );

                  return SizedBox.square(
                    dimension: size,
                    child: Consumer(
                      builder: (context, ref, child) => HoldWidget(
                        changeable: false,
                        initialState:
                            ref
                                .watch(wallStateProvider(hold.bank, hold.$num))
                                .valueOrNull ??
                            0,
                        hold: hold,
                        size: size * 0.8,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
