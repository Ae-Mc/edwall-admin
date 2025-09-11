import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hold_color.g.dart';

@Riverpod(keepAlive: true)
class HoldColor extends _$HoldColor {
  int _color = 1;

  @override
  int build() {
    return _color;
  }

  void set(int color) {
    _color = color;
    ref.invalidateSelf();
  }
}
