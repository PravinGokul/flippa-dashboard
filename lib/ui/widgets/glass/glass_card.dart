import 'package:flutter/material.dart';
import 'glass_container.dart';
import '../../theme/glass_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GlassCard({
    super.key, 
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: GlassTheme.blurSoft,
      background: GlassTheme.glassWhiteHigh,
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
