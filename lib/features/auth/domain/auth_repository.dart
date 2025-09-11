import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/features/auth/domain/selected_login.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  Future<UserRead?> build() {
    return keepAlive(ref, () async {
      final login = ref.watch(selectedLoginProvider);
      if (login == null) {
        return null;
      }
      final apiClient = await ref.read(apiClientProvider.future);
      final userResponse = await clientExceptionHandler(
        apiClient.apiV1UsersMeGet(),
      );
      if (userResponse.error != null) {
        Logger().e(userResponse.error);
      }

      return forceGetBody(userResponse);
    });
  }

  Future<void> authenticate(String username, String password) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final result = await clientExceptionHandler(
      apiClient.apiV1AuthLoginPost(
        body: {"username": username, "password": password},
      ),
    );
    final error = result.error;
    if (error != null) {
      if (result.statusCode == 400 || result.statusCode == 422) {
        switch (error) {
          case {"detail": "LOGIN_BAD_CREDENTIALS"}:
            throw ExceptionWithMessage("Неверное имя пользователя или пароль");
          case {
                "detail": [
                  {"loc": final List locations, "type": final String type},
                  ...,
                ],
              }
              when (locations.contains("username") ||
                      locations.contains("password")) &&
                  type == "missing":
            throw ExceptionWithMessage(
              "Имя пользователя и пароль не могут быть пустыми",
            );
        }
      } else if (result.statusCode == 500) {
        throw ExceptionWithMessage(
          "Произошла ошибка на сервере. Повторите попытку или свяжитесь с разработчиком",
        );
      }
      switch (error) {
        case {"detail": final detail} when detail is String:
          throw ExceptionWithMessage("Неизвестная ошибка: $detail");
        case _:
          Logger().e(error);
          throw ExceptionWithMessage(
            "Неизвестная ошибка: ${error.runtimeType}",
          );
      }
    }
    final body = result.body;
    if (body != null) {
      final newLogin = SavedLogin(token: body, username: username);
      await ref.read(settingsProvider.notifier).addSavedLogin(newLogin);
      await ref.read(selectedLoginProvider.notifier).selectLogin(newLogin);
    }

    ref.invalidateSelf();
  }

  Future<void> logout() async {
    final apiClient = (await ref.read(apiClientProvider.future));
    final result = await clientExceptionHandler(
      apiClient.apiV1AuthLogoutPost(),
    );
    final currentLogin = ref.read(selectedLoginProvider);
    if (currentLogin != null) {
      await ref.read(settingsProvider.notifier).removeSavedLogin(currentLogin);
      await ref.read(selectedLoginProvider.notifier).selectLogin(null);
    }
    ref.invalidateSelf();
    if (!result.isSuccessful) {
      Logger().d("Error exiting. Details: ${result.error}");
    }
  }

  Future<void> register(UserCreate user) async {
    final apiClient = await ref.read(apiClientProvider.future);
    final result = await clientExceptionHandler(
      apiClient.apiV1AuthRegisterPost(body: user),
    );
    if (!result.isSuccessful) {
      switch (result.error) {
        case {'detail': final List details}:
          for (final detail in details) {
            switch (detail) {
              case {'type': 'string_too_short', 'loc': final List loc}:
                String? field;
                switch (loc) {
                  case [..., "email"]:
                    field = "Email";
                  case [..., "password"]:
                    field = "Пароль";
                  case [..., "phone"]:
                    field = "Телефон";
                  case [..., "username"]:
                    field = "Логин";
                }
                if (field != null) {
                  final minLength = detail["ctx"]["min_length"];
                  throw ExceptionWithMessage(
                    '$field не должен быть короче $minLength символов!',
                  );
                }
              case {'type': 'value_error', 'loc': final List loc}:
                switch (loc) {
                  case ["body", "email"]:
                    throw ExceptionWithMessage("Проверьте формат email'а");
                  case ["body", "password"]:
                    throw ExceptionWithMessage(
                      "Что-то не так с паролем: ${result.error}",
                    );
                  case ["body", "phone"]:
                    throw ExceptionWithMessage(
                      "Проверьте формат номера телефона!",
                    );
                  case ["body", "username"]:
                    throw ExceptionWithMessage(
                      "Что-то не так с логином: ${result.error}",
                    );
                }
            }
          }
        case {
          'detail': {
            'code': 'REGISTER_INVALID_PASSWORD',
            'reason': final String reason,
          },
        }:
          throw ExceptionWithMessage(reason);
        case {'detail': 'REGISTER_USER_ALREADY_EXISTS'}:
          throw ExceptionWithMessage(
            'Пользователь с таким email, телефоном или паролем уже существует',
          );
      }
      Logger().e(result.error);

      throw ExceptionWithMessage(
        'При регистрации произошла ошибка: ${result.error}',
      );
    }
  }
}
