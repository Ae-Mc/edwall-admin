import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/features/auth/domain/selected_login.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AuthInterceptor implements InterceptorContract {
  SavedLogin? login;
  Settings settingsProvider;
  SelectedLogin selectedLoginProvider;

  AuthInterceptor({
    required this.settingsProvider,
    required this.selectedLoginProvider,
  });

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final localLogin = login;
    if (localLogin != null) {
      request.headers["Authorization"] =
          "${localLogin.token.tokenType} ${localLogin.token.accessToken}";
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (response.statusCode == 401) {
      final localLogin = login;
      if (localLogin != null) {
        final newToken = await Schema.create(baseUrl: hostBaseUrl)
            .apiV1AuthRefreshPost(
              body: BodyAuthBearerDatabaseRefreshApiV1AuthRefreshPost(
                refreshToken: localLogin.token.refreshToken,
              ),
            );
        final newLocalToken = newToken.body;
        if (newLocalToken == null) {
          await settingsProvider.removeSavedLogin(localLogin);
          await selectedLoginProvider.selectLogin(null);
          return response;
        }
        final newLogin = SavedLogin(
          token: newLocalToken,
          username: localLogin.username,
        );
        await selectedLoginProvider.selectLogin(newLogin);
        final request = response.request?.copyWith();
        if (request == null) {
          return response;
        }
        request.headers["Authorization"] =
            "${newToken.body!.tokenType} ${newToken.body!.accessToken}";

        return await request.send();
      }
    }

    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
