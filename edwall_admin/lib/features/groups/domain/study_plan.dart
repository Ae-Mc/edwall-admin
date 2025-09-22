import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'study_plan.g.dart';

@riverpod
Future<StudyPlanRead> studyPlan(Ref ref, int studyPlanId) {
  return keepAlive(ref, () async {
    final response = (await ref.read(
      apiClientProvider.future,
    )).apiV1StudyPlanStudyPlanIdGet(studyPlanId: studyPlanId);
    return forceGetBody(await clientExceptionHandler(response));
  });
}
