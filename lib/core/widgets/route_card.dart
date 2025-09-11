import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:intl/intl.dart';

class RouteCard extends StatelessWidget {
  final Route route;
  final bool selected;
  final bool compact;
  final void Function()? onTap;
  final void Function()? onDeleteTap;

  const RouteCard({
    super.key,
    this.compact = false,
    this.onDeleteTap,
    this.onTap,
    required this.route,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    var shape =
        Theme.of(context).cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    if (shape is RoundedRectangleBorder && selected) {
      shape = shape.copyWith(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    final nameHeader = Text(
      route.name,
      style: Theme.of(context).textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final difficultText = Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Сложность: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: route.difficult),
        ],
      ),
    );
    final modulesCountText = Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Количество модулей: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "${route.numberOfModules}"),
        ],
      ),
    );

    late final Widget content;
    if (compact) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                nameHeader,
                const SizedBox(height: 8),
                modulesCountText,
                const SizedBox(height: 8),
                difficultText,
              ],
            ),
          ),
          if (onDeleteTap != null) ...[
            const Box.gap(8),
            FloatingActionButton(
              onPressed: onDeleteTap,
              child: const Icon(Icons.delete),
            ),
          ],
        ],
      );
    } else {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                nameHeader,
                const SizedBox(height: 8),
                Text("Описание", style: Theme.of(context).textTheme.titleSmall),
                Text(route.description, maxLines: 3),
                const SizedBox(height: 8),
                difficultText,
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("yyyy-MM-dd hh:mm:ss").format(route.createdAt!),
                ),
                const SizedBox(height: 8),
                modulesCountText,
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
        ],
      );
    }

    return Card(
      shape: shape,
      child: CardInnerInkwell(
        onTap: onTap,
        child: Padding(padding: const Pad(all: 16), child: content),
      ),
    );
  }
}
