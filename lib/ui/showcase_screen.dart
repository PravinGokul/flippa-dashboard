import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';
import 'package:flippa/ui/widgets/glass/glass_button.dart';

class UIShowcaseScreen extends StatelessWidget {
  const UIShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2C)),
          onPressed: () => context.pop(),
        ),
        title: const Text("UI Component Library", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection("Typography", _buildTypography()),
          const SizedBox(height: 32),
          _buildSection("Color Tokens", _buildColorTokens()),
          const SizedBox(height: 32),
          _buildSection("Glass Components", _buildGlassComponents()),
          const SizedBox(height: 32),
          _buildSection("Buttons", _buildButtons()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildTypography() {
    return const GlassContainer(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Heading 1 - 24px Bold", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Heading 2 - 20px Bold", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Heading 3 - 18px SemiBold", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text("Body Text - 14px Normal. Used for general reading content.", style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text("Caption - 12px Regular", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildColorTokens() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildColorCircle(const Color(0xFF1E1E2C), "Primary\nDark"),
        _buildColorCircle(Colors.blueAccent, "Accent\nBlue"),
        _buildColorCircle(const Color(0xFFF8F9FD), "Background"),
        _buildColorCircle(const Color(0xFF94A3B8), "Text\nMuted"),
      ],
    );
  }

  Widget _buildColorCircle(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildGlassComponents() {
    return const Column(
      children: [
        GlassContainer(
          padding: EdgeInsets.all(16),
          child: Text("Standard Glass Container\nUsed for cards, panels, and distinct UI sections.", textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        GlassButton(label: "Primary Glass Button", onPressed: () {}, color: const Color(0xFF1E1E2C), width: double.infinity),
        const SizedBox(height: 16),
        GlassButton(label: "Secondary / Accent Button", onPressed: () {}, color: Colors.blueAccent, width: double.infinity),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Color(0xFF1E1E2C), width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Outlined Button", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
