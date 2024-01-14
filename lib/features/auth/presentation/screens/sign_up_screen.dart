import 'package:e_commerce/utils/exports.dart';

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
