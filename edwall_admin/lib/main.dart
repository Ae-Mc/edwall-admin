import 'dart:async';

import 'package:edwall_admin/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

void main() {
  runZonedGuarded(
    () => runApp(const ProviderScope(child: App())),
    (error, stack) => Logger(
      printer: PrettyPrinter(
        methodCount: 50,
        lineLength: 240,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    ).e(error.toString(), error: error, stackTrace: stack),
  );
}
