import 'package:e_commerce/utils/exports.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: FutureBuilder(
          future: authCubit.init(),
          builder: (context, snapshot) {
            return snapshot.data == true
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(18),
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          AuthHeaderWidget(title: 'Sign up'.tr()),
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
                                          hintText: 'Name'.tr(),
                                          validator: (value) => authCubit
                                              .checkNameValidation(value ?? ''),
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
                                      hintText: 'Email'.tr(),
                                      validator: (value) => authCubit
                                          .checkEmailValidation(value ?? ''),
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
                                      hintText: 'Password'.tr(),
                                      validator: (value) => authCubit
                                          .checkPasswordValidation(value ?? ''),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                AuthAlreadyHaveAnAccountOrForgotPassWidget(
                                  title: 'Already have an account'.tr(),
                                  onTap: () => authCubit
                                      .onTapAlreadyHaveAccountFunction(),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                AuthSubmitButton(
                                  title: 'SIGN UP'.tr(),
                                  onTap: () => authCubit.signUp(
                                      name:
                                          authCubit.nameController.text.trim(),
                                      email:
                                          authCubit.emailController.text.trim(),
                                      password: authCubit
                                          .passwordController.text
                                          .trim()),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                const AuthLoginOrSignUpWithSocialAccountWidget(
                                  text: 'Sign up',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
