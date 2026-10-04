import 'dart:math';

import 'package:flutter/widgets.dart';

EdgeInsets safeHorizontalPadding(BuildContext context, EdgeInsets minimum) {
  final systemPadding = MediaQuery.paddingOf(context);
  final safeLeft = systemPadding.left > 0 ? systemPadding.left + 8 : 0.0;
  final safeRight = systemPadding.right > 0 ? systemPadding.right + 8 : 0.0;
  return minimum.copyWith(
    left: max(minimum.left, safeLeft),
    right: max(minimum.right, safeRight),
  );
}
