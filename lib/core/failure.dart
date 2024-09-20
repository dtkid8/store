class Failure {
  final String errorMessage;
  final Map<String, dynamic>? errorJson;
  final StackTrace? stackTrace;
  final int? statusCode;

  Failure({
    required this.errorMessage,
    this.errorJson,
    this.stackTrace,
    this.statusCode,
  });
}
