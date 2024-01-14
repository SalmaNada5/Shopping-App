import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthDomainRepo {
  Future<Either<Failure, GoogleSignInAccount>> loginWithGmail(
      GoogleSignIn googleSignIn);
  Either<Failure, Unit> signOut();
  Future<Either<Failure, User?>> signUp(
      String name, String email, String password);
  Future<Either<Failure, User?>> login(String email, String password);
    Future<Either<Failure, LoginResult?>> loginWithFacebook();
}
