import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/exceptions.dart' as ex;
import 'package:e_commerce/core/errors/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteSource {
  Future<GoogleSignInAccount?> loginWithGoogleFunction(
      GoogleSignIn googleSignIn);
  void signOutFunction();
  Future<User?> signUpFunction(String name, String email, String password);
  Future<User?> loginFunction(String email, String password);
  Future<LoginResult?> logInWithFacebook();
}

class AuthRemoteSourceImplement implements AuthRemoteSource {
  @override
  Future<GoogleSignInAccount?> loginWithGoogleFunction(
      GoogleSignIn googleSignIn) async {
    try {
      final account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return account;
    } catch (e) {
      logError('error in loginWithGoogleFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if (e is FirebaseAuthException) {
        throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else {
        throw ex.OfflineException('$e');
      }
    }
  }

  @override
  void signOutFunction() {
    try {
      FirebaseAuth.instance.signOut();
      logSuccess("Signed out successfully");
    } catch (e) {
      logError('error in signOutFunction');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if (e is FirebaseAuthException) {
        throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else {
        throw ex.OfflineException('$e');
      }
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
      _storeUserData(
          email: email, name: name, userId: authResult.user?.uid ?? '');

      return authResult.user;
    } catch (e) {
      logError('Error in signUpFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if (e is FirebaseAuthException) {
        throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else {
        throw ex.OfflineException('$e');
      }
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
        logSuccess('Signed in successfully');
        return authResult.user;
      } else {
        logError('User information is null');
        return null;
      }
    } catch (e) {
      logError('Error in loginFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else {
        throw ex.OfflineException('$e');
      }
    }
  }

  @override
  Future<LoginResult?> logInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      logWarning('access token: ${result.accessToken}');
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      logWarning('credentional: $credential');
      await FirebaseAuth.instance.signInWithCredential(credential);
      // _addUserToFirestoreDataBase();
      final userData = await FacebookAuth.instance.getUserData();
      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'password': userData['password'],
        'name': userData['name']
      });
      return result;
    } catch (e) {
      logError('Error signing in with Facebook: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if (e is FirebaseAuthException) {
        throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else {
        throw ex.OfflineException('$e');
      }
    }
  }

  void _storeUserData(
      {required String email,
      required String name,
      required String userId}) async {
    // final userData = await FacebookAuth.instance.getUserData();
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await usersCollection.doc(userId).get();

    if (!userDoc.exists) {
      await usersCollection.doc(userId).set({
        'displayName': name,
        'email': email,
      });
      logInfo('New user added to firestore with id: ${userDoc.id}');
    }
  }
}
