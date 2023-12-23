class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}

class OfflineException implements Exception {
  final String message;
  final int statusCode;

  OfflineException({required this.message, required this.statusCode});
}
