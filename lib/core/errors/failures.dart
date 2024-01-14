import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure({required this.message});
  @override
  List<Object?> get props => [message];
}

final class FirebaseFailure extends Failure {
  const FirebaseFailure({required super.message});
}
final class FirebaseAuthFailure extends Failure {
  const FirebaseAuthFailure({required super.message});
}
final class OfflineFailure extends Failure {
  const OfflineFailure({required super.message});
}
