import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'active_study_plan.g.dart';

@Riverpod(keepAlive: true)
class ActiveStudyPlan extends _$ActiveStudyPlan {
  @override
  StudyPlan? build() {
    return stateOrNull;
  }

  void setStudyPlan(StudyPlan? studyPlan) {
    if (studyPlan != state) {
      state = studyPlan;
      ref.invalidateSelf();
    }
  }
}
