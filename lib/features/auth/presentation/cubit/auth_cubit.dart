import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/auth/domain/usecase/login.dart';
import 'package:e_commerce/features/auth/domain/usecase/sign_up.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.loginWithGmailUseCase, this.signUpUseCase, this.loginUseCase)
      : super(AuthInitial());
  final SignUpUseCase signUpUseCase;
  final LoginWithGmailUseCase loginWithGmailUseCase;
  final LoginUseCase loginUseCase;

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
      Constants.errorMessage(title: 'Unable to login!', description: l.message);
      return LoginFailure();
    }, (r) {
      logSuccess('Loged in with Gmail with account: $r');
      Constants.navigateTo(const HomePage());
      return LoginSuccess();
    });
  }

  //? login with email and password.
  void login({required String email, required String password}) async {
    if (loginFormKey.currentState!.validate()) {
      emit(AuthInitial());
      final Either<Failure, User?> res = await loginUseCase(email, password);
      emit(_loginSuccessOrFailureState(res));
      // changeEmailValidity();
    }
  }

  AuthState _loginSuccessOrFailureState(Either<Failure, User?> res) {
    return res.fold((l) {
      Constants.errorMessage(title: 'Unable to Login!', description: l.message);
      return LoginFailure();
    }, (r) {
      if (r != null) {
        logSuccess('Logged in with account: $r');
        logWarning('$r');
        Constants.navigateTo(const HomePage(), pushAndRemoveUntil: true);
        return LoginSuccess();
      } else {
        return LoginFailure();
      }
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
      Constants.errorMessage(
          title: 'Unable to Sign Up!', description: l.message);
      return SignUpFailure();
    }, (r) {
      logSuccess('Signed Up with account: $r');
      Constants.navigateTo(const HomePage());
      return SignUpSuccess();
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
      isValidEmail = false;
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
      isValidPassword = false;
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
}
