import 'package:e_commerce/utils/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  void signInWithGoogleSilently() async {
    try {
      await googleSignIn.signInSilently().then((account) {
        try {
          if (account != null) {
            Constants.navigateTo(const HomePage(), pushAndRemoveUntil: true);
            logWarning('Logged in silently..gmail login');
          }
        } catch (e) {
          logError('Error signing in silently: $e');
        }
      });
    } catch (error) {
      Constants.navigateTo(const LoginScreen(), pushAndRemoveUntil: true);
      logWarning('Error signing in silently: $error');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkAuthStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Constants.navigateTo(const HomePage(), pushAndRemoveUntil: true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    signInWithGoogleSilently();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderWidget(title: 'Sign up'),
              Form(
                key: authCubit.signUpFormKey,
                child: Column(
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AuthTextFormField(
                          controller: authCubit.nameController,
                          hintText: 'Name',
                          validator: (value) =>
                              authCubit.checkNameValidation(value ?? ''),
                          isValidInputData: authCubit.isValidName,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AuthTextFormField(
                      controller: authCubit.emailController,
                      hintText: 'Email',
                      validator: (value) =>
                          authCubit.checkEmailValidation(value ?? ''),
                      isValidInputData: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AuthTextFormField(
                      controller: authCubit.passwordController,
                      hintText: 'Password',
                      validator: (value) =>
                          authCubit.checkNameValidation(value ?? ''),
                      isValidInputData: false,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthAlreadyHaveAnAccountOrForgotPassWidget(
                      title: 'Already have an account',
                      onTap: () => authCubit.onTapAlreadyHaveAccountFunction(),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AuthSubmitButton(
                      title: 'SIGN UP',
                      onTap: () => authCubit.signUp(
                          name: authCubit.nameController.text.trim(),
                          email: authCubit.emailController.text.trim(),
                          password: authCubit.passwordController.text.trim()),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const AuthLoginOrSignUpWithSocialAccountWidget(
                      text: 'sign up',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
