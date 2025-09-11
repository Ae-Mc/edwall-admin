import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'study_groups.g.dart';

@riverpod
class MyStudyGroups extends _$MyStudyGroups {
  @override
  Future<List<StudyGroupRead>> build() {
    return keepAlive(ref, () async {
      final apiClient = await ref.watch(apiClientProvider.future);
      return forceGetBody(
        await clientExceptionHandler(apiClient.apiV1StudyGroupMyGet()),
      );
    });
  }

  Future<void> createStudyGroup(StudyGroupBaseExtended studyGroupCreate) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    await clientExceptionHandler(
      apiClient.apiV1StudyGroupPost(body: studyGroupCreate),
    );
    ref.invalidateSelf();
  }

  Future<void> updateGroup(int groupId, StudyGroupUpdate groupUpdate) async {
    final response = await clientExceptionHandler(
      (await ref.read(
        apiClientProvider.future,
      )).apiV1StudyGroupStudyGroupIdPatch(
        studyGroupId: groupId,
        body: groupUpdate,
      ),
    );
    if (!response.isSuccessful) {
      Logger().e('Failed to update group $groupId: ${response.error}');
    }
    response.bodyOrThrow;
    ref.invalidateSelf();
  }
}
