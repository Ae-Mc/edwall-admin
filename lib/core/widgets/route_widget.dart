import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/core/widgets/hold_widget.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteWidget extends ConsumerWidget {
  final WallRead? wall;
  final RouteRead route;

  const RouteWidget({super.key, required this.route, this.wall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (route.holds.isEmpty) {
      return const ErrorText(error: "Ошибка! Трасса без зацепок");
    }
    var localWall = wall;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (localWall == null) {
          final loadingWall = ref.watch(
            wallProvider(route.holds.first.wallhold.wallId),
          );
          if (loadingWall.hasValue) {
            localWall = loadingWall.valueOrNull;
          } else if (loadingWall.hasError) {
            return ErrorText(error: loadingWall.error!);
          } else {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }
        }
        if (localWall != null) {
          final moduleWidth = (localWall!.width / localWall!.numberOfModules)
              .round();
          final actualWallPartWidth = moduleWidth * route.numberOfModules;

          final height = constraints.maxHeight / (localWall!.height);
          final size = height;
          final holdsMap = List<Widget>.generate(
            actualWallPartWidth,
            (x) => Column(
              children: List.generate(localWall!.height, (y) {
                final hold = localWall!.holds.firstWhere(
                  (element) =>
                      element.numberInWall ==
                      (y * localWall!.width + x) % localWall!.holds.length,
                );
                final routeHold = route.holds.where(
                  (element) => element.wallhold.id == hold.id,
                );
                return SizedBox.square(
                  dimension: size,
                  child: HoldWidget(
                    initialState: routeHold.firstOrNull?.type ?? 0,
                    changeable: false,
                    hold: hold,
                    size: size * 0.8,
                  ),
                );
              }),
            ),
          );
          for (int i = route.numberOfModules - 1; i > 0; i--) {
            holdsMap.insert(i * moduleWidth, const VerticalDivider());
          }
          return ListView(scrollDirection: Axis.horizontal, children: holdsMap);
        }

        throw UnimplementedError("Impossible state");
      },
    );
  }
}
