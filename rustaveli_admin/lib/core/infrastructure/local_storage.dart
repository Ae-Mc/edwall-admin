import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'local_storage.g.dart';

@riverpod
Future<SharedPreferences> localStorage(Ref ref) =>
    SharedPreferences.getInstance();
