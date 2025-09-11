import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';

class ProgrammeCard extends StatelessWidget {
  final Programme programme;

  const ProgrammeCard({super.key, required this.programme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: CardInnerInkwell(
        onTap: () =>
            context.pushRoute(ProgrammeRoute(programmeId: programme.id)),
        child: Padding(
          padding: const Pad(all: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(programme.name, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(programme.description, maxLines: 3),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Сложность:"),
                  const SizedBox(width: 16),
                  ...List.filled(
                    min(programme.level, 10),
                    Padding(
                      padding: const Pad(right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        height: 16,
                        width: 16,
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
