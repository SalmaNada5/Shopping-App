import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/features/auth/data/source/local/local_source.dart';
import 'package:e_commerce/features/auth/data/source/remote/remote_source.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';

class AuthDataRepo implements AuthDomainRepo {
  final AuthRemoteSourceImplement authRemoteSourceImplement;
  final AuthLocalSourceImplement authLocalSourceImplement;
  AuthDataRepo(
      {required this.authLocalSourceImplement,
      required this.authRemoteSourceImplement});
  @override
  Future<Either<Failure, GoogleSignInAccount>> loginWithGmail(
      GoogleSignIn googleSignIn) async {
    try {
      final account =
          await authRemoteSourceImplement.loginWithGoogleFunction(googleSignIn);
      if (account != null) {
        authLocalSourceImplement.setUserId(account.id);
        return Right(account);
      } else {
        return const Left(OfflineFailure(message: 'No account selected'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Either<Failure, Unit> signOut(GoogleSignIn googleSignIn) {
    try {
      authRemoteSourceImplement.signOutFunction(googleSignIn);
      return const Right(unit);
    }  on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> signUp(String name, String email, String password) async{
    try{
     final user = await authRemoteSourceImplement.signUpFunction(name, email, password);
     return Right(user);
    } on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, User?>> login(String email, String password) async{
try{
     final user = await authRemoteSourceImplement.loginFunction(email, password);
     return Right(user);
    } on ServerException catch(e){
      return Left(ServerFailure(message: e.message));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }
  
}
