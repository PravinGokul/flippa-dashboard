import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsSubPage extends StatelessWidget {
  final String title;
  const SettingsSubPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF64748B)),
                Text("Back", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1E293B)),
        ),
        centerTitle: false,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: Colors.blue.withOpacity(0.2)),
            const SizedBox(height: 24),
            Text(
              "$title feature is coming soon!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 8),
            const Text(
              "We're currently building this for you.",
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}
