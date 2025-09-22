import 'package:chopper/chopper.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/infrastructure/http_client.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Future<Schema> apiClient(Ref ref) async {
  final httpClient = await ref.watch(httpClientProvider.future);
  final schema = Schema.create(
    baseUrl: hostBaseUrl,
    httpClient: httpClient,
    errorConverter: const JsonConverter(),
  );
  return schema;
}
