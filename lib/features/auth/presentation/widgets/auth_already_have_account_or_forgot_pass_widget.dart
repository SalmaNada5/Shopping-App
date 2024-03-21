import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthAlreadyHaveAnAccountOrForgotPassWidget extends StatelessWidget {
  const AuthAlreadyHaveAnAccountOrForgotPassWidget(
      {super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 14,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.arrow_right_alt,
            color: Color(0xffDB3022),
          )
        ],
      ).animate().slideY().fade(),
    );
  }
}
