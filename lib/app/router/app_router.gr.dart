// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [DeviceSelectPage]
class DeviceSelectRoute extends PageRouteInfo<DeviceSelectRouteArgs> {
  DeviceSelectRoute({
    required PageRouteInfo<Object?>? nextRoute,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DeviceSelectRoute.name,
         args: DeviceSelectRouteArgs(nextRoute: nextRoute, key: key),
         initialChildren: children,
       );

  static const String name = 'DeviceSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeviceSelectRouteArgs>();
      return DeviceSelectPage(nextRoute: args.nextRoute, key: args.key);
    },
  );
}

class DeviceSelectRouteArgs {
  const DeviceSelectRouteArgs({required this.nextRoute, this.key});

  final PageRouteInfo<Object?>? nextRoute;

  final Key? key;

  @override
  String toString() {
    return 'DeviceSelectRouteArgs{nextRoute: $nextRoute, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DeviceSelectRouteArgs) return false;
    return nextRoute == other.nextRoute && key == other.key;
  }

  @override
  int get hashCode => nextRoute.hashCode ^ key.hashCode;
}

/// generated route for
/// [GroupModifyPage]
class GroupModifyRoute extends PageRouteInfo<GroupModifyRouteArgs> {
  GroupModifyRoute({
    Key? key,
    required StudyGroupRead? initialGroup,
    List<PageRouteInfo>? children,
  }) : super(
         GroupModifyRoute.name,
         args: GroupModifyRouteArgs(key: key, initialGroup: initialGroup),
         initialChildren: children,
       );

  static const String name = 'GroupModifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupModifyRouteArgs>();
      return GroupModifyPage(key: args.key, initialGroup: args.initialGroup);
    },
  );
}

class GroupModifyRouteArgs {
  const GroupModifyRouteArgs({this.key, required this.initialGroup});

  final Key? key;

  final StudyGroupRead? initialGroup;

  @override
  String toString() {
    return 'GroupModifyRouteArgs{key: $key, initialGroup: $initialGroup}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupModifyRouteArgs) return false;
    return key == other.key && initialGroup == other.initialGroup;
  }

  @override
  int get hashCode => key.hashCode ^ initialGroup.hashCode;
}

/// generated route for
/// [GroupSelectPage]
class GroupSelectRoute extends PageRouteInfo<void> {
  const GroupSelectRoute({List<PageRouteInfo>? children})
    : super(GroupSelectRoute.name, initialChildren: children);

  static const String name = 'GroupSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GroupSelectPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [ProgrammeModifyPage]
class ProgrammeModifyRoute extends PageRouteInfo<ProgrammeModifyRouteArgs> {
  ProgrammeModifyRoute({
    Key? key,
    ProgrammeRead? initial,
    List<PageRouteInfo>? children,
  }) : super(
         ProgrammeModifyRoute.name,
         args: ProgrammeModifyRouteArgs(key: key, initial: initial),
         initialChildren: children,
       );

  static const String name = 'ProgrammeModifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProgrammeModifyRouteArgs>(
        orElse: () => const ProgrammeModifyRouteArgs(),
      );
      return ProgrammeModifyPage(key: args.key, initial: args.initial);
    },
  );
}

class ProgrammeModifyRouteArgs {
  const ProgrammeModifyRouteArgs({this.key, this.initial});

  final Key? key;

  final ProgrammeRead? initial;

  @override
  String toString() {
    return 'ProgrammeModifyRouteArgs{key: $key, initial: $initial}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgrammeModifyRouteArgs) return false;
    return key == other.key && initial == other.initial;
  }

  @override
  int get hashCode => key.hashCode ^ initial.hashCode;
}

/// generated route for
/// [ProgrammePage]
class ProgrammeRoute extends PageRouteInfo<ProgrammeRouteArgs> {
  ProgrammeRoute({
    Key? key,
    required int programmeId,
    List<PageRouteInfo>? children,
  }) : super(
         ProgrammeRoute.name,
         args: ProgrammeRouteArgs(key: key, programmeId: programmeId),
         initialChildren: children,
       );

  static const String name = 'ProgrammeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProgrammeRouteArgs>();
      return ProgrammePage(key: args.key, programmeId: args.programmeId);
    },
  );
}

class ProgrammeRouteArgs {
  const ProgrammeRouteArgs({this.key, required this.programmeId});

  final Key? key;

  final int programmeId;

  @override
  String toString() {
    return 'ProgrammeRouteArgs{key: $key, programmeId: $programmeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgrammeRouteArgs) return false;
    return key == other.key && programmeId == other.programmeId;
  }

  @override
  int get hashCode => key.hashCode ^ programmeId.hashCode;
}

/// generated route for
/// [ProgrammesPage]
class ProgrammesRoute extends PageRouteInfo<void> {
  const ProgrammesRoute({List<PageRouteInfo>? children})
    : super(ProgrammesRoute.name, initialChildren: children);

  static const String name = 'ProgrammesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProgrammesPage();
    },
  );
}

/// generated route for
/// [ProgrammesRouterPage]
class ProgrammesRouter extends PageRouteInfo<void> {
  const ProgrammesRouter({List<PageRouteInfo>? children})
    : super(ProgrammesRouter.name, initialChildren: children);

  static const String name = 'ProgrammesRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProgrammesRouterPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [RootPage]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RootPage();
    },
  );
}

/// generated route for
/// [RouteSelectPage]
class RouteSelectRoute extends PageRouteInfo<RouteSelectRouteArgs> {
  RouteSelectRoute({
    Key? key,
    List<int> excludeIds = const [],
    List<PageRouteInfo>? children,
  }) : super(
         RouteSelectRoute.name,
         args: RouteSelectRouteArgs(key: key, excludeIds: excludeIds),
         initialChildren: children,
       );

  static const String name = 'RouteSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RouteSelectRouteArgs>(
        orElse: () => const RouteSelectRouteArgs(),
      );
      return RouteSelectPage(key: args.key, excludeIds: args.excludeIds);
    },
  );
}

class RouteSelectRouteArgs {
  const RouteSelectRouteArgs({this.key, this.excludeIds = const []});

  final Key? key;

  final List<int> excludeIds;

  @override
  String toString() {
    return 'RouteSelectRouteArgs{key: $key, excludeIds: $excludeIds}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RouteSelectRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(excludeIds, other.excludeIds);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(excludeIds);
}

/// generated route for
/// [RoutesPage]
class RoutesRoute extends PageRouteInfo<void> {
  const RoutesRoute({List<PageRouteInfo>? children})
    : super(RoutesRoute.name, initialChildren: children);

  static const String name = 'RoutesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RoutesPage();
    },
  );
}

/// generated route for
/// [SandboxPage]
class SandboxRoute extends PageRouteInfo<void> {
  const SandboxRoute({List<PageRouteInfo>? children})
    : super(SandboxRoute.name, initialChildren: children);

  static const String name = 'SandboxRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SandboxPage();
    },
  );
}

/// generated route for
/// [SelectLoginPage]
class SelectLoginRoute extends PageRouteInfo<void> {
  const SelectLoginRoute({List<PageRouteInfo>? children})
    : super(SelectLoginRoute.name, initialChildren: children);

  static const String name = 'SelectLoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectLoginPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [StudyPlanSelectPage]
class StudyPlanSelectRoute extends PageRouteInfo<void> {
  const StudyPlanSelectRoute({List<PageRouteInfo>? children})
    : super(StudyPlanSelectRoute.name, initialChildren: children);

  static const String name = 'StudyPlanSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StudyPlanSelectPage();
    },
  );
}

/// generated route for
/// [WorkingGroupPage]
class WorkingGroupRoute extends PageRouteInfo<void> {
  const WorkingGroupRoute({List<PageRouteInfo>? children})
    : super(WorkingGroupRoute.name, initialChildren: children);

  static const String name = 'WorkingGroupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkingGroupPage();
    },
  );
}

/// generated route for
/// [WorkingLessonPage]
class WorkingLessonRoute extends PageRouteInfo<WorkingLessonRouteArgs> {
  WorkingLessonRoute({
    Key? key,
    required Lesson lesson,
    List<PageRouteInfo>? children,
  }) : super(
         WorkingLessonRoute.name,
         args: WorkingLessonRouteArgs(key: key, lesson: lesson),
         initialChildren: children,
       );

  static const String name = 'WorkingLessonRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkingLessonRouteArgs>();
      return WorkingLessonPage(key: args.key, lesson: args.lesson);
    },
  );
}

class WorkingLessonRouteArgs {
  const WorkingLessonRouteArgs({this.key, required this.lesson});

  final Key? key;

  final Lesson lesson;

  @override
  String toString() {
    return 'WorkingLessonRouteArgs{key: $key, lesson: $lesson}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkingLessonRouteArgs) return false;
    return key == other.key && lesson == other.lesson;
  }

  @override
  int get hashCode => key.hashCode ^ lesson.hashCode;
}

/// generated route for
/// [WorkingRoutePage]
class WorkingRouteRoute extends PageRouteInfo<void> {
  const WorkingRouteRoute({List<PageRouteInfo>? children})
    : super(WorkingRouteRoute.name, initialChildren: children);

  static const String name = 'WorkingRouteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkingRoutePage();
    },
  );
}
