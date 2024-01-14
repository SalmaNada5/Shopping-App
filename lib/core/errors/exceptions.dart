class FirebaseException implements Exception {
  final String message;

  FirebaseException(this.message);

  @override
  String toString() => 'FirebaseException: $message';
}

class FirebaseAuthException extends FirebaseException {
  FirebaseAuthException(String message) : super(message);
}

class FirebaseDatabaseException extends FirebaseException {
  FirebaseDatabaseException(String message) : super(message);
}
class OfflineException implements Exception {
  final String message;

  OfflineException(this.message);
}
// class ServerException implements Exception {
//   final String message;
//   final int statusCode;

//   ServerException({required this.message, required this.statusCode});
// }