import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/core/util/response_extension.dart';
import 'package:edwall_admin/features/groups/domain/lesson.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'lessons.g.dart';

var _ = 0;

final lessonsParentProvider = Provider<int>((ref) => _++);

@riverpod
class Lessons extends _$Lessons {
  @override
  Future<List<Lesson>> build() async {
    ref.watch(lessonsParentProvider);
    final activeStudyPlan = ref.watch(activeStudyPlanProvider);
    if (activeStudyPlan == null) {
      return [];
    }
    return keepAlive(ref, () async {
      final apiClient = await ref.watch(apiClientProvider.future);
      final response = await clientExceptionHandler(
        apiClient.apiV1StudyPlanStudyPlanIdLessonsGet(
          studyPlanId: activeStudyPlan.id,
        ),
      );
      response.raiseForStatusCode();
      return forceGetBody(response);
    });
  }

  Future<void> delete(int id) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    await clientExceptionHandler(
      apiClient.apiV1LessonsLessonIdDelete(lessonId: id),
    );
    ref.invalidate(lessonsParentProvider);
    ref.invalidate(lessonProvider(id));
  }

  Future<void> modify(
    int id,
    LessonUpdate lesson,
    List<int>? newRoutesIds,
  ) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    final response = await clientExceptionHandler(
      (newRoutesIds == null)
          ? apiClient.apiV1LessonsLessonIdPatch(lessonId: id, body: lesson)
          : apiClient.apiV1LessonsLessonIdPut(
              lessonId: id,
              body: BodyUpdateLessonFullApiV1LessonsLessonIdPut(
                lesson: lesson,
                routesIds: newRoutesIds,
              ),
            ),
    );
    response.raiseForStatusCode();
    ref.invalidate(lessonsParentProvider);
    ref.invalidate(lessonProvider(id));
  }

  Future<void> add(LessonBaseExtended lesson, [List<int>? routesIds]) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    (await clientExceptionHandler(
      routesIds == null
          ? apiClient.apiV1LessonsPost(body: lesson)
          : apiClient.apiV1LessonsFullPost(
              body: BodyCreateFullLessonApiV1LessonsFullPost(
                lesson: lesson,
                routesIds: routesIds,
              ),
            ),
    )).raiseForStatusCode();
    ref.invalidate(lessonsParentProvider);
  }
}
