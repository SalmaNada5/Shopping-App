import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/extensions.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit =
        BlocProvider.of<AuthCubit>(context, listen: false);
    authCubit.init();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: context.mediaQuery.viewInsets.bottom),
          child: Wrap(
            children: [
              const AuthHeaderWidget(title: 'Sign up'),
              Form(
                key: authCubit.signUpFormKey,
                child: Column(
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          bloc: authCubit,
                          buildWhen: (previous, current) =>
                              current is NameValidationChangedState,
                          builder: (context, state) {
                            return AuthTextFormField(
                              isValid: authCubit.isValidName,
                              controller: authCubit.nameController,
                              hintText: 'Name',
                              validator: (value) =>
                                  authCubit.checkNameValidation(value ?? ''),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      bloc: authCubit,
                      buildWhen: (previous, current) =>
                          current is EmailValidationChangedState,
                      builder: (context, state) {
                        return AuthTextFormField(
                          isValid: authCubit.isValidEmail,
                          controller: authCubit.emailController,
                          hintText: 'Email',
                          validator: (value) =>
                              authCubit.checkEmailValidation(value ?? ''),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      bloc: authCubit,
                      buildWhen: (previous, current) =>
                          current is PasswordValidationChangedState,
                      builder: (context, state) {
                        return AuthTextFormField(
                          isValid: authCubit.isValidPassword,
                          controller: authCubit.passwordController,
                          hintText: 'Password',
                          validator: (value) =>
                              authCubit.checkPasswordValidation(value ?? ''),
                        );
                      },
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
