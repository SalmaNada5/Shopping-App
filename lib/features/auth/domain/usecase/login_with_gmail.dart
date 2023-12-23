import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';

class LoginWithGmailUseCase {
  final AuthDomainRepo authDomainRepo;

  LoginWithGmailUseCase({required this.authDomainRepo});

  Future<Either<Failure, GoogleSignInAccount>> call(GoogleSignIn googleSignIn) => authDomainRepo.loginWithGmail(googleSignIn);
}
