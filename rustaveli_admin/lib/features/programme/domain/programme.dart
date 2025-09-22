import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'programme.g.dart';

@riverpod
Future<ProgrammeRead> programme(Ref ref, int id) async {
  final apiClient = await ref.watch(apiClientProvider.future);
  final response = await clientExceptionHandler(
    apiClient.apiV1ProgrammesProgrammeIdGet(programmeId: id),
  );
  return forceGetBody(response);
}
