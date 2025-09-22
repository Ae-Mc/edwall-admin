import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/features/groups/domain/completed_lessons.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:edwall_admin/features/groups/domain/selected_lesson.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'completed_routes.g.dart';

@riverpod
class CompletedRoutes extends _$CompletedRoutes {
  @override
  Future<Set<int>> build() {
    return keepAlive(ref, () async {
      final apiClient = await ref.read(apiClientProvider.future);

      final response = await clientExceptionHandler(
        apiClient.apiV1StudyGroupStudyGroupIdLessonIdCompletedRoutesIdsGet(
          studyGroupId: ref.watch(selectedGroupProvider)!.id,
          lessonId: ref.watch(selectedLessonProvider)!.id,
        ),
      );
      return Set<int>.from(await forceGetBody(response));
    });
  }

  Future<void> completeRoute(int routeId) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final lessonId = ref.watch(selectedLessonProvider)!.id;
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyGroupStudyGroupIdLessonIdRouteIdPost(
        studyGroupId: ref.watch(selectedGroupProvider)!.id,
        lessonId: lessonId,
        routeId: routeId,
      ),
    );
    if (!response.isSuccessful) {
      throw Exception(
        'Failed to complete route $routeId: StatusCode=${response.statusCode}, Body=${response.body}',
      );
    }
    if (response.statusCode == 208) {
      ref
          .read(completedLessonsProvider.notifier)
          .completeLessonLocally(lessonId);
    }
    state = state..valueOrNull?.add(routeId);
  }

  Future<void> makeRouteIncomplete(int routeId) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyGroupStudyGroupIdLessonIdRouteIdDelete(
        studyGroupId: ref.watch(selectedGroupProvider)!.id,
        lessonId: ref.watch(selectedLessonProvider)!.id,
        routeId: routeId,
      ),
    );
    if (!response.isSuccessful) {
      throw Exception('Failed to make route $routeId incomplete');
    }
    state = state..valueOrNull?.remove(routeId);
  }
}
