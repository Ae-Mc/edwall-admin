import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'completed_lessons.g.dart';

@riverpod
class CompletedLessons extends _$CompletedLessons {
  @override
  Future<Set<int>> build() {
    return keepAlive(ref, () async {
      final apiClient = await ref.read(apiClientProvider.future);

      final response = await clientExceptionHandler(
        apiClient.apiV1StudyGroupStudyGroupIdCompletedLessonsIdsGet(
          studyGroupId: ref.watch(selectedGroupProvider)!.id,
        ),
      );
      return Set<int>.from(forceGetBody(response));
    });
  }

  Future<void> completeLesson(int lessonId) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyGroupStudyGroupIdCompleteLessonLessonIdPost(
        studyGroupId: ref.watch(selectedGroupProvider)!.id,
        lessonId: lessonId,
      ),
    );
    if (!response.isSuccessful) {
      throw Exception('Failed to complete lesson $lessonId');
    }
    state = state..valueOrNull?.add(lessonId);
  }

  void completeLessonLocally(int lessonId) {
    state = state..valueOrNull?.add(lessonId);
  }

  Future<void> makeLessonIncomplete(int lessonId) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyGroupStudyGroupIdCompletedLessonsLessonIdDelete(
        studyGroupId: ref.watch(selectedGroupProvider)!.id,
        lessonId: lessonId,
      ),
    );
    if (!response.isSuccessful) {
      throw Exception('Failed to make lesson $lessonId incomplete');
    }
    state = state..valueOrNull?.remove(lessonId);
  }
}
