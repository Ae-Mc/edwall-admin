import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' show DateFormat;

class CurrentTimeWidget extends HookWidget {
  final TextAlign textAlign;
  const CurrentTimeWidget({this.textAlign = TextAlign.right, super.key});

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
    painter.width;

    return SizedBox(
      width: painter.width + 15,
      child: Text(
        DateFormat("dd ${DateFormat.MONTH} ${DateFormat.YEAR} HH:mm.ss")
            .format(now.value),
        textAlign: TextAlign.left,
      ),
    );
  }
}
