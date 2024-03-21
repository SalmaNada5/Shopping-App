import 'package:e_commerce/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:e_commerce/utils/exports.dart';
import 'package:e_commerce/utils/shake_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: PopScope(
        onPopInvoked: (didPop) => authCubit.clearTextControllers(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  AuthHeaderWidget(title: 'Login'.tr()),
                  Form(
                    key: authCubit.loginFormKey,
                    child: Column(
                      children: [
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return AuthTextFormField(
                              controller: authCubit.emailController,
                              hintText: 'Email'.tr(),
                              validator: (value) =>
                                  authCubit.checkEmailValidation(value ?? ''),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return ShakeWidget(
                              key: authCubit.passwordTextFieldShakeKey,
                              child: AuthTextFormField(
                                obscure: authCubit.obsecure,
                                suffixIcon: GestureDetector(
                                  child: authCubit.obsecure
                                      ? const Icon(
                                          CupertinoIcons.eye_slash_fill,
                                          size: 20,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          CupertinoIcons.eye_fill,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                  onTap: () => authCubit.changeObsecure(),
                                ),
                                controller: authCubit.passwordController,
                                hintText: 'Password'.tr(),
                                validator: (value) => authCubit
                                    .checkPasswordValidation(value ?? ''),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AuthAlreadyHaveAnAccountOrForgotPassWidget(
                            onTap: () => Constants.navigateTo(
                                const ForgotPasswordScreen()),
                            title: 'Forgot your password?'.tr()),
                        const SizedBox(
                          height: 40,
                        ),
                        AuthSubmitButton(
                          title: 'LOGIN'.tr(),
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
        ),
      ),
    );
  }
}
