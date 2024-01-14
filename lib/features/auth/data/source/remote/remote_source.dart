import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_commerce/core/errors/exceptions.dart' as ex;

abstract class AuthRemoteSource {
  Future<GoogleSignInAccount?> loginWithGoogleFunction(
      GoogleSignIn googleSignIn);
  void signOutFunction();
  Future<User?> signUpFunction(String name, String email, String password);
  Future<User?> loginFunction(String email, String password);
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _storeUserData(userCredential.user!);
      return account;
    } catch (e) { 
      logError('error in loginWithGoogleFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if(e is FirebaseAuthException){
                throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else{
        throw ex.OfflineException('$e');
      }
    }
    
  }

  @override
  void signOutFunction() {
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      logError('error in signOutFunction');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if(e is FirebaseAuthException){
                throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else{
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
      _storeUserData(authResult.user!);

      return authResult.user;
    } catch (e) {
      logError('Error in signUpFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if(e is FirebaseAuthException){
                throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else{
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
        logSuccess('Sign in successful: ${authResult.user?.displayName}');
        return authResult.user;
      } else {
        logError('User information is null');
        return null;
      }
    } catch (e) {
      logError('Error in loginFunction: $e');
      if (e is FirebaseAuthException) {
        throw ex.FirebaseException(e.message ?? 'Error occured');
      } else if(e is FirebaseAuthException){
                throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else{
        throw ex.OfflineException('$e');
      }
    }
  }

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
      } else if(e is FirebaseAuthException){
                throw ex.FirebaseAuthException(e.message ?? 'Error occured');
      } else{
        throw ex.OfflineException('$e');
      }
    }
  }

  void _storeUserData(User user) async {
    // final userData = await FacebookAuth.instance.getUserData();
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await usersCollection.doc(user.uid).get();

    if (!userDoc.exists) {
      await usersCollection.doc(user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
      });
      logInfo('New user added to firestore with id: ${userDoc.id}');
    }
  }
}
