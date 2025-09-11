import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final StudyGroupRead group;
  final bool selected;
  final Future<void> Function()? onTap;
  final Future<void> Function()? onPlanSelect;
  final Future<void> Function()? onContinueSelect;

  const GroupCard({
    super.key,
    required this.group,
    required this.selected,
    this.onTap,
    this.onPlanSelect,
    this.onContinueSelect,
  });

  @override
  Widget build(BuildContext context) {
    late final Color borderColor;
    if (selected) {
      borderColor = Theme.of(context).colorScheme.primary;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
    final cardShape =
        Theme.of(context).cardTheme.shape as RoundedRectangleBorder;

    conditionalInkWell({required Widget? child}) => onTap == null
        ? child
        : InkWell(
            borderRadius: cardShape.borderRadius.resolve(TextDirection.ltr),
            onTap: onTap,
            child: child,
          );
    return Card(
      shape: cardShape.copyWith(side: BorderSide(color: borderColor)),
      elevation: selected ? null : 0,
      child: conditionalInkWell(
        child: Padding(
          padding: Pad(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(group.name, style: titleStyle),
              if (selected) ...[
                Text(
                  group.description,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const Box.gap(16),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => context.pushRoute(
                        GroupModifyRoute(initialGroup: group),
                      ),
                      child: Text('РЕДАКТИРОВАТЬ'),
                    ),
                    Spacer(),
                    FutureButton(
                      onPressed: () async => await onPlanSelect?.call(),
                      child: Text('УЧЕБНЫЙ ПЛАН'),
                    ),
                    Box.gap(16),
                    FutureButton(
                      onPressed: () async => await onContinueSelect?.call(),
                      child: Text('ПРОДОЛЖИТЬ УРОК'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
