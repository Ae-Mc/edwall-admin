import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/auth/data/auth_interceptor.dart';
import 'package:edwall_admin/features/auth/domain/selected_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'http_client.g.dart';

@Riverpod(keepAlive: true)
Future<InterceptedClient> httpClient(Ref ref) async {
  final authInterceptor = AuthInterceptor(
    settingsProvider: ref.watch(settingsProvider.notifier),
    selectedLoginProvider: ref.watch(selectedLoginProvider.notifier),
  );
  authInterceptor.login = ref.watch(selectedLoginProvider);
  return InterceptedClient.build(
    interceptors: [authInterceptor],
    requestTimeout: Duration(seconds: 5),
  );
}
