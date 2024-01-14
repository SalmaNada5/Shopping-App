import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';
import 'package:e_commerce/utils/exports.dart';

class SignOutUseCase {
  final AuthDomainRepo authDomainRepo;

  SignOutUseCase({required this.authDomainRepo});

 Either<Failure, Unit> call() =>
      authDomainRepo.signOut();
}
