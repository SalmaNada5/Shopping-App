import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginWithFacebookUseCase {
  final AuthDomainRepo authDomainRepo;

  LoginWithFacebookUseCase({required this.authDomainRepo});
  Future<Either<Failure, LoginResult?>> call() => authDomainRepo.loginWithFacebook();
}
