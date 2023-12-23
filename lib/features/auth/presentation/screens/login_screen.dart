import 'package:e_commerce/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:e_commerce/utils/exports.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderWidget(title: 'Login'),
              Form(
                key: authCubit.loginFormKey,
                child: Column(
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AuthTextFormField(
                          controller: authCubit.emailController,
                          hintText: 'Email',
                          validator: (value) =>
                              authCubit.checkEmailValidation(value ?? ''),
                          isValidInputData: authCubit.isValidEmail,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AuthTextFormField(
                          controller: authCubit.passwordController,
                          hintText: 'Password',
                          validator: (value) =>
                              authCubit.checkPasswordValidation(value ?? ''),
                          isValidInputData: authCubit.isValidPassword,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthAlreadyHaveAnAccountOrForgotPassWidget(
                        onTap: () =>
                            Constants.navigateTo(const ForgotPasswordScreen()),
                        title: 'Forgot your password?'),
                    const SizedBox(
                      height: 40,
                    ),
                    AuthSubmitButton(
                      title: 'LOGIN',
                      onTap: () => authCubit.login(
                          email: authCubit.emailController.text.trim(),
                          password: authCubit.passwordController.text.trim()),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const AuthLoginOrSignUpWithSocialAccountWidget(
                      text: 'Login',
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
