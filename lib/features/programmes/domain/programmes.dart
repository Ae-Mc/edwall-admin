import 'dart:math';

import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/response_extension.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'programmes.g.dart';

@riverpod
int programmesParent(Ref ref) => Random().nextInt(10);

@riverpod
class Programmes extends _$Programmes {
  @override
  Future<List<Programme>> build({
    String? nameContains,
    int? levelFrom,
    int? levelTo,
  }) async {
    ref.watch(programmesParentProvider);
    final apiClient = await ref.watch(apiClientProvider.future);
    final response = await clientExceptionHandler(
      apiClient.apiV1ProgrammesGet(
        nameContains: nameContains,
        levelFrom: levelFrom,
        levelTo: levelTo,
      ),
    );
    return forceGetBody(response);
  }

  Future<void> delete(int id) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    await clientExceptionHandler(
      apiClient.apiV1ProgrammesProgrammeIdDelete(programmeId: id),
    );
    ref.invalidate(programmesParentProvider);
    ref.invalidate(programmeProvider(id));
  }

  Future<void> modify(
    int id,
    ProgrammeUpdate programme,
    List<int>? newRoutesIds,
  ) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    Logger().d('Modifying programme $id: $programme ($newRoutesIds)');
    final response = await clientExceptionHandler(
      (newRoutesIds == null)
          ? apiClient.apiV1ProgrammesProgrammeIdPatch(
              programmeId: id,
              body: programme,
            )
          : apiClient.apiV1ProgrammesProgrammeIdPut(
              programmeId: id,
              body: BodyUpdateProgrammeFullApiV1ProgrammesProgrammeIdPut(
                programme: programme,
                routesIds: newRoutesIds,
              ),
            ),
    );
    response.raiseForStatusCode();
    ref.invalidate(programmesParentProvider);
    ref.invalidate(programmeProvider(id));
  }

  Future<void> add(ProgrammeBase programme, {List<int>? routesIds}) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    await clientExceptionHandler(
      routesIds == null
          ? apiClient.apiV1ProgrammesPost(body: programme)
          : apiClient.apiV1ProgrammesFullPost(
              body: BodyCreateFullProgrammeApiV1ProgrammesFullPost(
                programme: programme,
                routesIds: routesIds,
              ),
            ),
    );
    ref.invalidate(programmesParentProvider);
  }
}
