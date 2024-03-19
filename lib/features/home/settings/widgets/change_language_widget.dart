import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        context.locale.languageCode == 'en' ? 'العربيه' : 'English',
        style: const TextStyle(
          color: Color(0xFFDB3022),
          fontSize: 16,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        context.locale.languageCode == 'en'
            ? context.setLocale(const Locale('ar'))
            : context.setLocale(const Locale('en'));
        WidgetsBinding.instance.performReassemble();
      },
    );
  }
}
