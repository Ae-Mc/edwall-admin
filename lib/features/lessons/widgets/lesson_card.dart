import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: CardInnerInkwell(
        onTap: () => context.pushRoute(LessonRoute(lessonId: lesson.id)),
        child: Padding(
          padding: const Pad(all: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(lesson.name, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(lesson.description, maxLines: 3),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
