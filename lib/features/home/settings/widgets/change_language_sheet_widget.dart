import 'package:flutter/material.dart';

class ChangeLanguageSheetWidget extends StatelessWidget {
  const ChangeLanguageSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, -4),
            spreadRadius: 0,
          )
        ],
      ),
      child: const Column(
        children: [],
      ),
    );
  }
}
