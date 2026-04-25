import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../state/global_state_bloc.dart';
import '../../../core/auth/auth_service.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        title: const Text("Settings", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle("Account"),
          _buildSettingsTile(Icons.person_outline, "Edit Profile", "Name, Email, Phone", () {}),
          _buildSettingsTile(Icons.lock_outline, "Security", "Password, Two-factor auth", () {}),
          _buildSettingsTile(Icons.payment_outlined, "Payment Methods", "Cards, UPI, Bank accounts", () {}),
          
          const SizedBox(height: 32),
          _buildSectionTitle("Preferences"),
          _buildLanguageTile(context),
          _buildCurrencyTile(context),
          _buildSettingsTile(Icons.notifications_none, "Notifications", "Push, Email, SMS", () {}),
          
          const SizedBox(height: 32),
          _buildSectionTitle("Support & About"),
          _buildSettingsTile(Icons.help_outline, "Help Center", "FAQs, Contact support", () {}),
          _buildSettingsTile(Icons.privacy_tip_outline, "Privacy Policy", "Data usage and protection", () {}),
          _buildSettingsTile(Icons.info_outline, "Terms of Service", "App rules and regulations", () {}),
          
          const SizedBox(height: 48),
          _buildSignOutButton(context),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Flippa v1.0.4 - Built with ❤️ in India",
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: const Color(0xFF1E293B), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildSettingsTile(
          Icons.language_outlined,
          "Language",
          state.locale.languageCode == 'en' ? "English" : "Hindi (हिंदी)",
          () {
            // Show language picker
          },
        );
      },
    );
  }

  Widget _buildCurrencyTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildSettingsTile(
          Icons.payments_outlined,
          "Currency",
          state.currency,
          () {
            // Show currency picker
          },
        );
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.read<AuthService>().signOut();
        if (context.mounted) context.go('/login');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 12),
            Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
