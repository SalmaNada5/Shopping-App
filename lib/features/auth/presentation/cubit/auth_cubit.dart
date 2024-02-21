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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
      this.loginWithGmailUseCase,
      this.signUpUseCase,
      this.loginUseCase,
      this.loginWithFacebookUseCase,
      this.signOutUseCase,
      this._authLocalSourceImplement)
      : super(AuthInitial());
  final SignUpUseCase signUpUseCase;
  final LoginWithGmailUseCase loginWithGmailUseCase;
  final LoginUseCase loginUseCase;
  final LoginWithFacebookUseCase loginWithFacebookUseCase;
  final SignOutUseCase signOutUseCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthLocalSourceImplement _authLocalSourceImplement;
  Future<bool> init() async {
    logWarning("user id: $userId");
    if (userId != null && userId != '') {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        logWarning("exist");
        Future.delayed(Duration.zero, () async {
          await Constants.navigateTo(const HomePage(),
              pushAndRemoveUntil: true);
        });
        return true;
      }
    } else {
      Future.delayed(Duration.zero, () async {
        await Constants.navigateTo(const LoginScreen(),
            pushAndRemoveUntil: true);
      });
      return true;
    }
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

  String? get userName => _authLocalSourceImplement.getUserName;
  String? get userId => _authLocalSourceImplement.getUserId;
  String? get userPhotoUrl => _authLocalSourceImplement.getUserPhotoUrl;
  //* login
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //? login with gmail.
  void loginWithGmail() async {
    emit(AuthInitial());
    final Either<Failure, GoogleSignInAccount> res =
        await loginWithGmailUseCase(googleSignIn);
    emit(_loginWithGmailSuccessOrFailState(res));
  }

  AuthState _loginWithGmailSuccessOrFailState(
      Either<Failure, GoogleSignInAccount> res) {
    return res.fold((l) {
      Constants.showSnackbar(l.message);
      return LoginFailure();
    }, (r) {
      logSuccess('Logged in with Gmail with account: $r');
      _authLocalSourceImplement.setUserId(r.id);
      _authLocalSourceImplement.setUserName(r.displayName ?? "");
      _authLocalSourceImplement.setUserPhotoUrl(r.photoUrl ?? "");

      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      return LoginSuccess();
    });
  }

  //? login with email and password.
  void login({required String email, required String password}) async {
    if (loginFormKey.currentState!.validate()) {
      emit(AuthInitial());
      Constants.showLoading();
      final Either<Failure, User?> res = await loginUseCase(email, password);
      Constants.hideLoadingOrNavBack();
      emit(_loginSuccessOrFailureState(res));
    }
  }

  AuthState _loginSuccessOrFailureState(Either<Failure, User?> res) {
    return res.fold((l) {
      Constants.showSnackbar(l.message);
      return LoginFailure();
    }, (r) {
      if (r != null) {
        logSuccess('Logged in with account: $r');
        logWarning('$r');
        _authLocalSourceImplement.setUserId(r.uid);
        _authLocalSourceImplement.setUserName(r.displayName ?? "");
        _authLocalSourceImplement.setUserPhotoUrl(r.photoURL ?? "");

        Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
        return LoginSuccess();
      } else {
        return LoginFailure();
      }
    });
  }

//? login with facebook
  void loginWithFacebook() async {
    emit(AuthInitial());
    final Either<Failure, LoginResult?> res = await loginWithFacebookUseCase();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(_loginWithFacebookSuccessOrFailState(res));
      }
    });
  }

  AuthState _loginWithFacebookSuccessOrFailState(
      Either<Failure, LoginResult?> res) {
    return res.fold((l) {
      Constants.showSnackbar(l.message);
      return LoginFailure();
    }, (r) {
      logSuccess('Logged in with Facebook with account: $r');
      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      return LoginSuccess();
    });
  }

  //* sign up
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  void onTapAlreadyHaveAccountFunction() {
    emailController.clear();
    passwordController.clear();
    Constants.navigateTo(const LoginScreen());
  }

  void signUp(
      {required String name,
      required String email,
      required String password}) async {
    if (signUpFormKey.currentState!.validate()) {
      emit(AuthInitial());
      final Either<Failure, User?> res =
          await signUpUseCase(name, email, password);
      emit(_signUpSuccessOrFailureState(res));
    }
  }

  AuthState _signUpSuccessOrFailureState(Either<Failure, User?> res) {
    return res.fold((l) {
      Constants.showSnackbar(l.message);
      return SignUpFailure();
    }, (r) {
      logSuccess('Signed Up with account: $r');
      _authLocalSourceImplement.setUserId(r?.uid ?? '');
      _authLocalSourceImplement.setUserName(r?.displayName ?? "");
      _authLocalSourceImplement.setUserPhotoUrl(r?.photoURL ?? "");

      Constants.navigateTo(const MainPage(), pushAndRemoveUntil: true);
      return SignUpSuccess();
    });
  }

//* signout
  void signOutFunction() {
    emit(AuthInitial());
    final Either<Failure, Unit> res = signOutUseCase();
    emit(_signOutSuccessOrFailureState(res));
  }

  AuthState _signOutSuccessOrFailureState(Either<Failure, Unit> res) {
    return res.fold((l) {
      Constants.showSnackbar(l.message);
      return SignOutFailure();
    }, (r) {
      logSuccess('Signed out Successfully');
      Constants.navigateTo(const LoginScreen(), pushAndRemoveUntil: true);
      return SignOutSuccess();
    });
  }

  //! text form fields validations
  bool? isValidName;
  String? checkNameValidation(String value) {
    emit(AuthInitial());
    value = nameController.text;
    if (value.isEmpty) {
      isValidName = false;
      emit(NameValidationChangedState());
      return 'Please enter your name';
    } else {
      isValidName = true;
      emit(NameValidationChangedState());
      return null;
    }
  }

  bool? isValidEmail;

  String? checkEmailValidation(String value) {
    value = emailController.text;
    if (value.isEmpty) {
      emit(EmailValidationChangedState());
      return 'Please enter your e-mail';
    } else if (!value.isEmail) {
      isValidEmail = false;
      emit(EmailValidationChangedState());
      return 'Please Enter a valid e-mail';
    } else {
      isValidEmail = true;
      emit(EmailValidationChangedState());
      return null;
    }
  }

  bool? isValidPassword;
  String? checkPasswordValidation(String value) {
    emit(AuthInitial());
    value = passwordController.text;
    if (value.isEmpty) {
      emit(PasswordValidationChangedState());
      return 'Please enter your password';
    } else if (value.length < 8) {
      isValidPassword = false;
      emit(PasswordValidationChangedState());
      return 'Password must be at least 8 characters long';
    } else if (value.length > 32) {
      isValidPassword = false;
      emit(PasswordValidationChangedState());
      return 'Password must not be more than 32 characters long';
    } else {
      isValidPassword = true;
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
        logWarning('cur email ${_auth.currentUser?.email}');
        if (_auth.currentUser?.email == emailController.text.trim()) {
          await _auth.sendPasswordResetEmail(
              email: emailController.text.trim());
          logSuccess('email sent');
          Constants.navigateTo(const LoginScreen(), pushAndRemoveUntil: true);
          ScaffoldMessenger.of(Constants.navigatorKey.currentContext!)
              .showSnackBar(
            const SnackBar(
              content: Text(
                  'Password reset email sent successfully, Please login again with your new password.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(Constants.navigatorKey.currentContext!)
              .showSnackBar(
            const SnackBar(
              content: Text('This email doesn\'t match current user email!'),
            ),
          );
        }
      } catch (e) {
        logError('error in onForgotPasswordSendButtonTapped: $e');
      }
    }
  }

  // _clearTextControllers() {
  //   nameController.clear();
  //   emailController.clear();
  //   passwordController.clear();
  // }
}
