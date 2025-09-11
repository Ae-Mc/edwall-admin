import 'dart:async';
import 'dart:io';

import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

Future<T> clientExceptionHandler<T>(Future<T> requestFuture) async {
  try {
    return await requestFuture.timeout(const Duration(seconds: 5));
  } on ClientException catch (e) {
    Logger().e(e);
    throw ExceptionWithMessage("Проверьте подключение к интернету");
  } on HandshakeException catch (e) {
    Logger().e(e);
    throw ExceptionWithMessage("Ошибка сети! Повторите попытку");
  } on TimeoutException {
    throw ExceptionWithMessage(
      "Время ожидания ответа сервера истекло. Повторите попытку позже",
    );
  }
}
