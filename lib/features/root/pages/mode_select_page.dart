import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ModeSelectPage extends StatelessWidget {
  const ModeSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Учебник")),
            Box.gap(16),
            ElevatedButton(
              onPressed: () => context.router.push(StudyPlansRoute()),
              child: Text("Учебные планы"),
            ),
          ],
        ),
      ),
    );
  }
}
