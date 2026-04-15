import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final double overlayAlpha;

  const AppBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/luz_purpura.png',
    this.overlayAlpha = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: overlayAlpha)),
        ),
        child,
      ],
    );
  }
}