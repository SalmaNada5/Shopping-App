import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteSource {
  Future<GoogleSignInAccount?> loginWithGoogleFunction(
      GoogleSignIn googleSignIn);
  void signOutFunction(GoogleSignIn googleSignIn);
  Future<User?> signUpFunction(String name, String email, String password);
  Future<User?> loginFunction(String email, String password);
}

class AuthRemoteSourceImplement implements AuthRemoteSource {
  @override
  Future<GoogleSignInAccount?> loginWithGoogleFunction(
      GoogleSignIn googleSignIn) async {
    try {
      final account = await googleSignIn.signIn();
      return account;
    } catch (e) {
      logError('error in loginWithGoogleFunction: $e');
      return null;
    }
  }

  @override
  void signOutFunction(GoogleSignIn googleSignIn) {
    try {
      //sign out after login with gmail
      googleSignIn.signOut();
    } catch (e) {
      logError('error in signOutFunction');
    }
  }

  @override
  Future<User?> signUpFunction(
      String name, String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await authResult.user!.updateDisplayName(name);
      return authResult.user;
    } catch (e) {
      logError('Error in signUpFunction: $e');
      return null;
    }
  }

  @override
  Future<User?> loginFunction(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        logSuccess('Sign in successful: ${authResult.user?.displayName}');
        return authResult.user;
      } else {
        logError('User information is null');
        return null;
      }
    } catch (e) {
      logError('Error in loginFunction: $e');
      return null;
    }
  }

  Future<void> logInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      logWarning('access token: ${result.accessToken}');
      final userData = await FacebookAuth.instance.getUserData();
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      logWarning('credentional: $credential');

      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'password': userData['password'],
        'name': userData['name']
      });
    } catch (e) {
      logError('Error signing in with Facebook: $e');
    }
  }
}
