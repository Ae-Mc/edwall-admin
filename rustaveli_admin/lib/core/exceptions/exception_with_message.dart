class ExceptionWithMessage implements Exception {
  final String message;
  ExceptionWithMessage(this.message);

  @override
  String toString() => message;
}
