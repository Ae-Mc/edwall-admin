import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' show DateFormat;

class CurrentTimeWidget extends HookWidget {
  final TextAlign textAlign;
  final double trailingPadding;
  const CurrentTimeWidget({
    this.textAlign = TextAlign.left,
    this.trailingPadding = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = useState(DateTime.now());
    useEffect(
      () =>
          Timer(Duration(seconds: 1), () => now.value = DateTime.now()).cancel,
    );
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    final painter = TextPainter(
      text: TextSpan(
        text: "dd ${DateFormat.MONTH} ${DateFormat.YEAR} HH:mm.ss",
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return SizedBox(
      width: painter.width + trailingPadding,
      child: Text(
        DateFormat(
          "dd ${DateFormat.MONTH} ${DateFormat.YEAR} HH:mm.ss",
        ).format(now.value),
        textAlign: textAlign,
      ),
    );
  }
}
