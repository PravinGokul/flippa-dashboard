import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _twoFactorEnabled = true;

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
        title: const Text("Security", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSecurityHeader(),
          const SizedBox(height: 32),
          _buildSectionHeader("Account Security"),
          _buildActionTile(Icons.password_rounded, "Change Password", "Last updated 3 months ago", Colors.blue, () {}),
          _buildToggleTile(Icons.security_rounded, "Two-Factor Auth", "Highly recommended", Colors.amber, _twoFactorEnabled, (val) => setState(() => _twoFactorEnabled = val)),
          
          const SizedBox(height: 32),
          _buildSectionHeader("Login Activity"),
          _buildActivityItem("iPhone 15 Pro", "Mumbai, India • Active Now", true),
          _buildActivityItem("Chrome on Windows", "Pune, India • 2 days ago", false),
          _buildActivityItem("MacBook Pro", "Bengaluru, India • Oct 12", false),
        ],
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      background: Colors.green.withOpacity(0.05),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: Colors.green, size: 40),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your account is secure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                Text("We recommend reviewing your security settings every 90 days.", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, Color color, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1E293B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String device, String details, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(device.contains("iPhone") ? Icons.smartphone_rounded : Icons.laptop_windows_rounded, color: const Color(0xFF64748B), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                  Text(details, style: TextStyle(fontSize: 12, color: isActive ? Colors.green : const Color(0xFF94A3B8))),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Text("Current", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
