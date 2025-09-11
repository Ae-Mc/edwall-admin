import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T> keepAlive<T>(Ref ref, Future<T> Function() function) async {
  final link = ref.keepAlive();
  try {
    return await function();
  } catch (e) {
    link.close();
    rethrow;
  }
}
