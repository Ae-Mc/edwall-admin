import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final studyPlansProvider = FutureProvider<List<StudyPlan>>((ref) {
  return keepAlive(ref, () async {
    final apiClient = await ref.watch(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1StudyPlanGet(),
    );
    return forceGetBody(response);
  });
});
