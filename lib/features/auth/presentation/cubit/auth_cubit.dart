import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/data/source/local/local_source.dart';
import 'package:e_commerce/features/auth/domain/usecase/login.dart';
import 'package:e_commerce/features/auth/domain/usecase/login_with_facebook.dart';
import 'package:e_commerce/features/auth/domain/usecase/sign_out.dart';
import 'package:e_commerce/features/auth/domain/usecase/sign_up.dart';
import 'package:e_commerce/features/home/presentation/screens/main_page.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/extensions.dart';
import 'package:e_commerce/utils/shake_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
      this._loginWithGmailUseCase,
      this._signUpUseCase,
      this._loginUseCase,
      this._loginWithFacebookUseCase,
      this._signOutUseCase,
      this._authLocalSourceImplement)
      : super(AuthInitial());
  final SignUpUseCase _signUpUseCase;
  final LoginWithGmailUseCase _loginWithGmailUseCase;
  final LoginUseCase _loginUseCase;
  final LoginWithFacebookUseCase _loginWithFacebookUseCase;
  final SignOutUseCase _signOutUseCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthLocalSourceImplement _authLocalSourceImplement;
  Future<bool> init() async {
    if (userId != null && userId != '') {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        logWarning("exist");
        Future.delayed(Duration.zero, () async {
          await Constants.navigateTo(const MainPage(),
              pushAndRemoveUntil: true);
        });
        return true;
      }
    }
    // else {
    //   Future.delayed(Duration.zero, () async {
    //     await Constants.navigateTo(const SignUpScreen(),
    //         pushAndRemoveUntil: true);
    //   });
    //   return true;
    // }
    return false;
// //? check already signed in with google
//     GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
//     try {
//       await googleSignIn.signInSilently().then((account) {
//         try {
//           if (account != null) {
//             Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
//             logWarning('Logged in silently..gmail login');
//           }
//         } catch (e) {
//           logError('Error signing in silently: $e');
//         }
//       });
//     } catch (error) {
//       Constants.navigateTo(const LoginScreen(), pushAndRemoveUntil: true);
//       logWarning('Error signing in silently: $error');
//     }

// //? check user auth
//     User? user = _auth.currentUser;

//     if (user != null) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
    // });
//     }

// //? check already signed in with facebook
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         logWarning('User is currently signed out');
//       } else {
//         Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
//       }
//     });
  }

  Future<bool> _doesUserEmailExist() async {
    try {
      // List<String> methods = [];
      Constants.showLoading();
      // methods = await FirebaseAuth.instance
      //     .fetchSignInMethodsForEmail(emailController.text.trim());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text.trim())
          .get();
      Constants.hideLoadingOrNavBack();
      if (querySnapshot.docs.isNotEmpty) {
        logInfo('Email exist');
        return true;
      } else {
        logInfo('Email not exist:${emailController.text.trim()}');
        return false;
      }
    } catch (e) {
      Constants.hideLoadingOrNavBack();
      logError('error in _doesEmailExist: $e');
      return false;
    }
  }

  String? get userName => _authLocalSourceImplement.getUserName;
  String? get userId => _authLocalSourceImplement.getUserId;
  //* login
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //? login with gmail.
  void loginWithGmail() async {
    emit(AuthInitial());
    final Either<Failure, GoogleSignInAccount> res =
        await _loginWithGmailUseCase(googleSignIn);
    emit(_loginWithGmailSuccessOrFailState(res));
  }

  AuthState _loginWithGmailSuccessOrFailState(
      Either<Failure, GoogleSignInAccount> res) {
    return res.fold((l) {
      Constants.showSnackbar(
          "An unexpected error occurred. Please try again later".tr());
      return LoginFailure();
    }, (r) {
      logSuccess('Logged in with Gmail with account: $r');
      _authLocalSourceImplement.setUserId(r.id);
      _authLocalSourceImplement.setUserName(r.displayName ?? "");

      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      return LoginSuccess();
    });
  }

  //? login with email and password.
  final passwordTextFieldShakeKey = GlobalKey<ShakeWidgetState>();
  void login({required String email, required String password}) async {
    if (loginFormKey.currentState!.validate()) {
      emit(AuthInitial());
      if (await _doesUserEmailExist()) {
        Constants.showLoading();
        final Either<Failure, User?> res = await _loginUseCase(email, password);
        Constants.hideLoadingOrNavBack();
        emit(_loginSuccessOrFailureState(res));
      } else {
        Constants.showSnackbar(
            "We couldn't find this email. Consider signing up if you're new!"
                .tr());
      }
    }
  }

  AuthState _loginSuccessOrFailureState(Either<Failure, User?> res) {
    return res.fold((l) {
      if (l.message == "invalid-credential") {
        passwordTextFieldShakeKey.currentState?.shakeWidget();
        Constants.showSnackbar(
            "Sorry, the password you entered is incorrect. Please double-check your password and try again"
                .tr());
      } else {
        Constants.showSnackbar(
            'An unexpected error occurred. Please try again later'.tr());
      }
      return LoginFailure();
    }, (r) {
      if (r != null) {
        logSuccess('Logged in with account: $r');
        _authLocalSourceImplement.setUserId(r.uid);
        _authLocalSourceImplement.setUserName(r.displayName ?? "");
        Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
        clearTextControllers();
        return LoginSuccess();
      } else {
        return LoginFailure();
      }
    });
  }

  bool obsecure = true;
  bool signupObscure = true;
  void changeObsecure({bool fromSignup = false}) {
    emit(AuthInitial());
    if (fromSignup) {
      signupObscure = !signupObscure;
    } else {
      obsecure = !obsecure;
    }
    emit(ObsecureTextChanged());
  }

//? login with facebook
  void loginWithFacebook() async {
    emit(AuthInitial());
    final Either<Failure, LoginResult?> res = await _loginWithFacebookUseCase();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(_loginWithFacebookSuccessOrFailState(res));
      }
    });
  }

  AuthState _loginWithFacebookSuccessOrFailState(
      Either<Failure, LoginResult?> res) {
    return res.fold((l) {
      logError("error in loginWithFacebook: ${l.message}");
      Constants.showSnackbar(
          "An unexpected error occurred. Please try again later".tr());
      return LoginFailure();
    }, (r) {
      logSuccess('Logged in with Facebook with account: $r');
      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      return LoginSuccess();
    });
  }

  //? sign up
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  void onTapAlreadyHaveAccountFunction() {
    clearTextControllers();
    Constants.navigateTo(const LoginScreen());
  }

  void signUp(
      {required String name,
      required String email,
      required String password}) async {
    if (signUpFormKey.currentState!.validate()) {
      emit(AuthInitial());
      Constants.showLoading();
      final Either<Failure, User?> res =
          await _signUpUseCase(name, email, password);
      Constants.hideLoadingOrNavBack();
      emit(_signUpSuccessOrFailureState(res));
    }
  }

  AuthState _signUpSuccessOrFailureState(Either<Failure, User?> res) {
    return res.fold((l) {
      if (l.message == 'email-already-in-use') {
        Constants.showSnackbar(
            'The account already exists for that email.'.tr());
      } else {
        logError("error in signUp: ${l.message}");
        Constants.showSnackbar(
            "An unexpected error occurred. Please try again later".tr());
      }
      return SignUpFailure();
    }, (r) {
      logSuccess('Signed Up with account: $r');
      _authLocalSourceImplement.setUserId(r?.uid ?? '');
      _authLocalSourceImplement.setUserName(r?.displayName ?? "");
      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      clearTextControllers();
      r?.sendEmailVerification();
      return SignUpSuccess();
    });
  }

//? signout
  void signOutFunction() {
    emit(AuthInitial());
    final Either<Failure, Unit> res = _signOutUseCase();
    emit(_signOutSuccessOrFailureState(res));
  }

  AuthState _signOutSuccessOrFailureState(Either<Failure, Unit> res) {
    return res.fold((l) {
      logError("error in signOutFunction: ${l.message}");
      Constants.showSnackbar(
          "An unexpected error occurred. Please try again later".tr());
      return SignOutFailure();
    }, (r) {
      logSuccess('Signed out Successfully');
      Constants.navigateTo(const SignUpScreen(), pushAndRemoveUntil: true);
      return SignOutSuccess();
    });
  }

  //* text form fields validations
  String? checkNameValidation(String value) {
    emit(AuthInitial());
    value = nameController.text;
    if (value.isEmpty) {
      emit(NameValidationChangedState());
      return 'Please enter your name'.tr();
    } else {
      emit(NameValidationChangedState());
      return null;
    }
  }

  String? checkEmailValidation(String value) {
    value = emailController.text;
    if (value.isEmpty) {
      emit(EmailValidationChangedState());
      return 'Please enter your e-mail'.tr();
    } else if (!value.isEmail) {
      emit(EmailValidationChangedState());
      return 'Please Enter a valid e-mail'.tr();
    } else {
      emit(EmailValidationChangedState());
      return null;
    }
  }

  String? checkPasswordValidation(String value) {
    emit(AuthInitial());
    value = passwordController.text;
    if (value.isEmpty) {
      emit(PasswordValidationChangedState());
      return 'Please enter your password'.tr();
    } else if (value.length < 8) {
      emit(PasswordValidationChangedState());
      return 'Password must be at least 8 characters long'.tr();
    } else if (value.length > 32) {
      emit(PasswordValidationChangedState());
      return 'Password must not be more than 32 characters long'.tr();
    } else {
      emit(PasswordValidationChangedState());
      return null;
    }
  }

  final forgotPassFormKey = GlobalKey<FormState>();

  //* Forgot password
  void onForgotPasswordSendButtonTapped() async {
    if (forgotPassFormKey.currentState!.validate()) {
      emit(AuthInitial());
      try {
        if (await _doesUserEmailExist()) {
          await _auth.sendPasswordResetEmail(
              email: emailController.text.trim());
          logSuccess('email sent');
          Navigator.pop(Constants.navigatorKey.currentContext!);
          ScaffoldMessenger.of(Constants.navigatorKey.currentContext!)
              .showSnackBar(
            SnackBar(
              content: Text(
                  "Success! We've sent you an email to reset your password. Please log in again using your new password."
                      .tr()),
            ),
          );
        } else {
          ScaffoldMessenger.of(Constants.navigatorKey.currentContext!)
              .showSnackBar(
            SnackBar(
              content: Text(
                  "Sorry, we couldn't find this email address or it hasn't been verified yet. Please double-check your email or verify your account if you haven't already."
                      .tr()),
            ),
          );
        }
      } catch (e) {
        logError('error in onForgotPasswordSendButtonTapped: $e');
      }
    }
  }

  clearTextControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
