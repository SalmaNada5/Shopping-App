import 'package:e_commerce/utils/exports.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeaderWidget(
              title: 'Forgot password',
              bottomPadding: 140,
            ),
            const Text(
              'Please, enter your email address. You will receive a link to create a new password via email.',
              style: TextStyle(
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
                      controller: authCubit.emailController,
                      hintText: 'Email',
                      validator: (value) =>
                          authCubit.checkEmailValidation(value ?? ''),
                      isValidInputData: authCubit.isValidEmail),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            AuthSubmitButton(
              title: 'Send',
              onTap: () => authCubit.onForgotPasswordSendButtonTapped(),
            ),
          ],
        ),
      )),
    );
  }
}
