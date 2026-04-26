import 'package:flutter/material.dart';
import 'dart:ui';

class GlobalBackground extends StatelessWidget {
  final Widget child;
  const GlobalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF8F9FD), // Base light grey color
      child: Stack(
        children: [
          // Top Left Blob (Purple)
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withOpacity(0.25),
              ),
            ),
          ),
          // Top Right Blob (Blue)
          Positioned(
            top: 50,
            right: -100,
            child: Container(
              width: 700,
              height: 700,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.22),
              ),
            ),
          ),
          // Bottom Left Blob (Teal)
          Positioned(
            bottom: -150,
            left: -50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal.withOpacity(0.2),
              ),
            ),
          ),
          // Center Right Blob (Indigo)
          Positioned(
            top: 300,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withOpacity(0.18),
              ),
            ),
          ),
          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
          child,
        ],
      ),
    );
  }
}
