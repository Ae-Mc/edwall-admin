import 'package:chopper/chopper.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';

T forceGetBody<T>(Response<T> response) {
  final body = response.body;

  if (body != null) {
    return body;
  }

  final error = response.error;
  if (error == null) {
    throw UnimplementedError("Null body, null error. Impossible state!");
  }
  throw ExceptionWithMessage(
    "Неизвестная ошибка (${response.statusCode}): $error",
  );
}
