import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';

class LoginWithFacebookUseCase {
  final AuthDomainRepo authDomainRepo;

  LoginWithFacebookUseCase({required this.authDomainRepo});
  Future<Either<Failure, Unit>> call() => authDomainRepo.loginWithFacebook();
}
