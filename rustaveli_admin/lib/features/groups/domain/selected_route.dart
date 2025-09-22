import 'package:edwall_admin/core/providers/route.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_route.g.dart';

@Riverpod(keepAlive: true)
class SelectedRoute extends _$SelectedRoute {
  RouteRead? _selected;
  @override
  RouteRead? build() => _selected;

  void setRoute(RouteRead? route) {
    if (route != _selected) {
      _selected = route;
      ref.invalidateSelf();
    }
  }

  Future<RouteRead> loadRoute(int routeId) async {
    if (_selected?.id != routeId) {
      final route = await ref.read(routeProvider(routeId).future);
      setRoute(route);
    }
    return _selected!;
  }
}
