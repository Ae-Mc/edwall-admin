import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'wall.g.dart';

@riverpod
Future<WallRead> wall(Ref ref, int id) {
  return keepAlive(ref, () async {
    final apiClient = await ref.watch(apiClientProvider.future);
    return forceGetBody(
      await clientExceptionHandler(apiClient.apiV1WallsWallIdGet(wallId: id)),
    );
  });
}
