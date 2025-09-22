import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/response_extension.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'study_plans.g.dart';

var _ = 0;

final studyPlansParentProvider = Provider<int>((ref) => _++);

@riverpod
class StudyPlans extends _$StudyPlans {
  @override
  Future<List<StudyPlan>> build() async {
    ref.watch(studyPlansParentProvider);
    final apiClient = await ref.watch(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyPlanGet(),
    );
    response.raiseForStatusCode();
    return forceGetBody(response);
  }

  Future<void> delete(int id) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    await clientExceptionHandler(
      apiClient.apiV1StudyPlanStudyPlanIdDelete(studyPlanId: id),
    );
    ref.invalidate(studyPlansParentProvider);
    final activeStudyPlan = ref.read(activeStudyPlanProvider);
    if (activeStudyPlan?.id == id) {
      ref.read(activeStudyPlanProvider.notifier).setStudyPlan(null);
    }
  }

  Future<void> modify(int id, StudyPlanUpdate studyPlan) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyPlanStudyPlanIdPatch(
        studyPlanId: id,
        body: studyPlan,
      ),
    );
    response.raiseForStatusCode();
    ref.invalidate(studyPlansParentProvider);
  }

  Future<void> add(StudyPlanBase studyPlan) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    (await clientExceptionHandler(
      apiClient.apiV1StudyPlanPost(body: studyPlan),
    )).raiseForStatusCode();
    ref.invalidate(studyPlansParentProvider);
  }
}
