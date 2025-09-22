import 'package:chopper/chopper.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:logger/logger.dart';

extension ResponseExtension on Response {
  void raiseForStatusCode() {
    if (statusCode < 200 || statusCode >= 300) {
      Logger().e(bodyString);
      throw ExceptionWithMessage(
        'Неожиданный код ответа сервера ($statusCode). Попробуйте ещё раз или свяжитесь с поддержкой.',
      );
    }
  }
}
