import 'dart:math';

import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({super.key, required this.child});
  final Widget child;
  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateAnimationStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateAnimationStatus);
    animationController.dispose();
    super.dispose();
  }

  void _updateAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shakeWidget() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue = sin(6 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: child,
        );
      },
    );
  }
}
