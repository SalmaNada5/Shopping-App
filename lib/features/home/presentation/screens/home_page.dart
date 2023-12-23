import 'package:flutter/material.dart';
import 'package:e_commerce/features/auth/presentation/widgets/auth_header_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthHeaderWidget(title: 'Home'),
    );
  }
}
