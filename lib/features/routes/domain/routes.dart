import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/providers/route.dart';
import 'package:edwall_admin/core/util/response_extension.dart';
import 'package:edwall_admin/features/routes/domain/current_route_edit_parameters.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'routes.g.dart';

var _ = 0;

final routesParentProvider = Provider<int>((Ref ref) => _++);

@riverpod
class Routes extends _$Routes {
  @override
  Future<List<Route>> build({
    String? nameContains,
    int? numberOfModulesFrom,
    int? numberOfModulesTo,
  }) async {
    ref.watch(routesParentProvider);
    final apiClient = await ref.watch(apiClientProvider.future);
    return forceGetBody(
      await clientExceptionHandler(
        apiClient.apiV1RoutesGet(
          nameContains: nameContains,
          numberOfModulesFrom: numberOfModulesFrom,
          numberOfModulesTo: numberOfModulesTo,
        ),
      ),
    );
  }

  Future<void> delete(int id) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    (await clientExceptionHandler(
      apiClient.apiV1RoutesRouteIdDelete(routeId: id),
    )).raiseForStatusCode();
    ref.invalidate(routesParentProvider);
    ref.invalidate(routeProvider(id));
    final params = ref.read(currentRouteEditParametersProvider);
    if (params.id == id) {
      ref.read(currentRouteEditParametersProvider.notifier).setRouteId(null);
    }
  }

  Future<void> modify(
    int id,
    RouteUpdate route, [
    List<(int, int)>? newHolds,
  ]) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    (await clientExceptionHandler(
      (newHolds == null)
          ? apiClient.apiV1RoutesRouteIdPatch(routeId: id, body: route)
          : apiClient.apiV1RoutesRouteIdPut(
              routeId: id,
              body: BodyReplaceRouteApiV1RoutesRouteIdPut(
                route: route,
                wallHolds: newHolds.map((e) => [e.$1, e.$2]).toList(),
              ),
            ),
    )).raiseForStatusCode();
    ref.invalidate(routesParentProvider);
    ref.invalidate(routeProvider(id));
  }

  Future<RouteRead> add(RouteBase route, [List<(int, int)>? holds]) async {
    final apiClient = await ref.watch(apiClientProvider.future);
    Logger().d(holds);
    final response = await clientExceptionHandler(
      holds == null
          ? apiClient.apiV1RoutesPost(body: route)
          : apiClient.apiV1RoutesFullPost(
              body: BodyAddRouteFullApiV1RoutesFullPost(
                route: route,
                wallHolds: holds.map((e) => [e.$1, e.$2]).toList(),
              ),
            ),
    );
    response.raiseForStatusCode();
    ref.invalidate(routesParentProvider);
    return forceGetBody(response);
  }
}
