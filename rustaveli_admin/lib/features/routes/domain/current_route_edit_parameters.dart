import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_route_edit_parameters.g.dart';
part 'current_route_edit_parameters.freezed.dart';

@unfreezed
sealed class RouteEditParameters with _$RouteEditParameters {
  factory RouteEditParameters({
    int? id,
    required final TextEditingController name,
    required final TextEditingController description,
    required final TextEditingController difficulty,
  }) = _$RouteEditParametersConst;
}

@Riverpod(keepAlive: true)
class CurrentRouteEditParameters extends _$CurrentRouteEditParameters {
  final RouteEditParameters _params = RouteEditParameters(
    name: TextEditingController(),
    description: TextEditingController(),
    difficulty: TextEditingController(),
  );

  @override
  RouteEditParameters build() {
    return _params;
  }

  void setRouteId(int? id) {
    if (id == _params.id) return;
    _params.id = id;
    ref.invalidateSelf();
  }

  void setParamsFromRoute(Route route) {
    _params.id = route.id;
    _params.name.text = route.name;
    _params.description.text = route.description;
    _params.difficulty.text = route.difficult;
    ref.invalidateSelf();
  }

  void clear() {
    _params.id = null;
    _params.name.text = '';
    _params.description.text = '';
    _params.difficulty.text = '';
    ref.invalidateSelf();
  }
}
