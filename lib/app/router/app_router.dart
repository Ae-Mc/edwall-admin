import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/features/textbook/pages/route_modify_page.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:edwall_admin/features/auth/pages/login_page.dart';
import 'package:edwall_admin/features/auth/pages/register_page.dart';
import 'package:edwall_admin/features/auth/pages/select_login_page.dart';
import 'package:edwall_admin/features/bluetooth/pages/device_select_page.dart';
import 'package:edwall_admin/features/lesson/pages/lesson_modify_page.dart';
import 'package:edwall_admin/features/lesson/pages/new_route_select_page.dart';
import 'package:edwall_admin/features/lessons/pages/lessons_page.dart';
import 'package:edwall_admin/features/programme/pages/programme_modify_page.dart';
import 'package:edwall_admin/features/root/pages/mode_select_page.dart';
import 'package:edwall_admin/features/root/pages/root_page.dart';
import 'package:edwall_admin/features/splash/pages/splash_page.dart';
import 'package:edwall_admin/features/study_plans/pages/study_plans_page.dart';
import 'package:edwall_admin/features/study_plans/pages/study_plan_modify_page.dart';
import 'package:edwall_admin/features/textbook/pages/textbook_page.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_router.gr.dart';
part 'app_router.g.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: DeviceSelectRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(
      page: RootRoute.page,
      children: [
        AutoRoute(page: LessonsRoute.page),
        AutoRoute(page: LessonModifyRoute.page),
        AutoRoute(page: ModeSelectRoute.page, initial: true),
        AutoRoute(page: NewRouteSelectRoute.page),
        AutoRoute(page: ProgrammeModifyRoute.page),
        AutoRoute(page: RouteModifyRoute.page),
        AutoRoute(page: StudyPlansRoute.page),
        AutoRoute(page: StudyPlanModifyRoute.page),
        AutoRoute(page: TextbookRoute.page),
      ],
    ),
    AutoRoute(page: SelectLoginRoute.page),
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}

@riverpod
Raw<AppRouter> appRouter(Ref ref) {
  return AppRouter();
}
