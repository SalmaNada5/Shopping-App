import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';

class SignUpUseCase {
  final AuthDomainRepo authDomainRepo;

  SignUpUseCase({required this.authDomainRepo});
  Future<Either<Failure, User?>> call(
          String name, String email, String password) =>
      authDomainRepo.signUp(name, email, password);
}
