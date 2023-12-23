import 'package:flutter/material.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key, required this.title, this.bottomPadding = 70});
  final String title;
  final double bottomPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF222222),
          fontSize: 36,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
