import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('GlassButton tapped: $label');
            onPressed();
          },
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            blur: 10,
            background: Colors.white.withOpacity(0.1),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: const Color(0xFF1E1E2C),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
