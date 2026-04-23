import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/glass_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color background;
  final EdgeInsets padding;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = GlassTheme.blurStrong,
    this.background = GlassTheme.glassWhiteLow,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlassTheme.radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: GlassTheme.radius,
            border: Border.all(color: GlassTheme.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Match CSS: rgba(0,0,0,0.1)
                blurRadius: 30, // Match CSS
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
