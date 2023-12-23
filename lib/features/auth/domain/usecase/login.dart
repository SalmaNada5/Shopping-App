import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUseCase {
  final AuthDomainRepo authDomainRepo;

  LoginUseCase({required this.authDomainRepo});
  Future<Either<Failure, User?>> call(String email, String password) =>
      authDomainRepo.login(email, password);
}
