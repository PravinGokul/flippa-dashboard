import 'package:flutter/material.dart';
import 'dart:ui';

class GlobalBackground extends StatefulWidget {
  final Widget child;
  const GlobalBackground({super.key, required this.child});

  @override
  State<GlobalBackground> createState() => _GlobalBackgroundState();
}

class _GlobalBackgroundState extends State<GlobalBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-specific colors
    final baseColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FD);
    final purpleColor = const Color(0xFF7C3AED).withOpacity(isDark ? 0.35 : 0.25);
    final blueColor = const Color(0xFF3B82F6).withOpacity(isDark ? 0.3 : 0.22);
    final tealColor = const Color(0xFF14B8A6).withOpacity(isDark ? 0.25 : 0.2);
    final indigoColor = Colors.indigo.withOpacity(isDark ? 0.22 : 0.18);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: baseColor,
      child: Stack(
        children: [
          // Animated Blobs
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Top Left Blob (Purple)
                  Positioned(
                    top: -100 + (20 * _controller.value),
                    left: -50 + (30 * _controller.value),
                    child: _Blob(size: 600, color: purpleColor),
                  ),
                  // Top Right Blob (Blue)
                  Positioned(
                    top: 50 - (40 * _controller.value),
                    right: -100 + (20 * _controller.value),
                    child: _Blob(size: 750, color: blueColor),
                  ),
                  // Bottom Left Blob (Teal)
                  Positioned(
                    bottom: -150 + (30 * _controller.value),
                    left: -50 - (20 * _controller.value),
                    child: _Blob(size: 550, color: tealColor),
                  ),
                  // Center Right Blob (Indigo)
                  Positioned(
                    top: 350 + (50 * _controller.value),
                    right: -120 - (30 * _controller.value),
                    child: _Blob(size: 450, color: indigoColor),
                  ),
                ],
              );
            },
          ),
          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
