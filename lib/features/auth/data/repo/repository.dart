import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/features/auth/data/source/local/local_source.dart';
import 'package:e_commerce/features/auth/data/source/remote/remote_source.dart';
import 'package:e_commerce/features/auth/domain/repo/repository.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Either<Failure, Unit> signOut() {
    try {
      authRemoteSourceImplement.signOutFunction();
      authLocalSourceImplement.removeUserId;
      authLocalSourceImplement.removeUserName;
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, firebase.User?>> signUp(
      String name, String email, String password) async {
    try {
      final user =
          await authRemoteSourceImplement.signUpFunction(name, email, password);
      authLocalSourceImplement.setUserId(user?.uid ?? '');
      authLocalSourceImplement.setUserName(user?.displayName ?? name);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, firebase.User?>> login(
      String email, String password) async {
    try {
      final user =
          await authRemoteSourceImplement.loginFunction(email, password);
      authLocalSourceImplement.setUserId(user?.uid ?? '');
      authLocalSourceImplement.setUserName(user?.displayName ?? '');

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResult?>> loginWithFacebook() async {
    try {
      final user = await authRemoteSourceImplement.logInWithFacebook();
      authLocalSourceImplement.setUserId(user?.accessToken?.userId ?? '');
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.code));
    } on OfflineException catch (e) {
      return Left(OfflineFailure(message: e.message));
    }
  }
}
