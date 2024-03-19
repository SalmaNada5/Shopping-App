import 'package:e_commerce/utils/exports.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeaderWidget(
              title: 'Forgot password'.tr(),
              bottomPadding: 140,
            ),
            Text(
              'Please, enter your email address. You will receive a link to create a new password via email.'
                  .tr(),
              style: const TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Form(
                  key: authCubit.forgotPassFormKey,
                  child: AuthTextFormField(
                    isValid: authCubit.isValidPassword,
                    controller: authCubit.emailController,
                    hintText: 'Email'.tr(),
                    validator: (value) =>
                        authCubit.checkEmailValidation(value ?? ''),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            AuthSubmitButton(
              title: 'Send'.tr(),
              onTap: () => authCubit.onForgotPasswordSendButtonTapped(),
            ),
          ],
        ),
      )),
    );
  }
}
