import 'package:e_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthLoginOrSignUpWithSocialAccountWidget extends StatelessWidget {
  const AuthLoginOrSignUpWithSocialAccountWidget({
    super.key,
    required this.text,
  });

  final String text; //this text used to specific it's login or signup
  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Column(
      children: [
        Text(
          text.contains('Sign')
              ? "Or Sign up with social account".tr()
              : "Or Login with social account".tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontSize: 14,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w500,
            height: 0.10,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => authCubit.loginWithGmail(),
              child: Container(
                width: 92,
                height: 64,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 8,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: SvgPicture.asset('assets/images/gmail.svg'),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () => authCubit.loginWithFacebook(),
              child: Container(
                width: 92,
                height: 64,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 8,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: SvgPicture.asset('assets/images/facebook.svg'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
