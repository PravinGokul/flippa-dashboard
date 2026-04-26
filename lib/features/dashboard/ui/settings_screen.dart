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
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Color(0xFF1E293B)),
        ),
        centerTitle: false,
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[100], height: 1),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          
          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDesktopSection("Account", [
                        _buildDesktopTile(Icons.person, "Edit Profile", "Name, Email, Phone", const Color(0xFF7C3AED), () => context.push('/settings/profile')),
                        _buildDesktopTile(Icons.lock_person, "Security", "Password, Two-factor auth", Colors.amber, () => context.push('/settings/security')),
                        _buildDesktopTile(Icons.payment, "Payment Methods", "Cards, UPI, Bank accounts", Colors.blue, () => context.push('/settings/payment')),
                      ]),
                      _buildDesktopSection("Preferences", [
                        _buildDesktopLanguageTile(context),
                        _buildDesktopCurrencyTile(context),
                        _buildDesktopTile(Icons.notifications, "Notifications", "Push, Email, SMS", Colors.orange, () => context.push('/settings/notifications')),
                      ]),
                      _buildDesktopSection("Support & About", [
                        _buildDesktopTile(Icons.help_center, "Help Center", "FAQs, Contact support", Colors.redAccent, () => context.push('/settings/help')),
                        _buildDesktopTile(Icons.privacy_tip, "Privacy Policy", "Data usage and protection", Colors.blueAccent, () => context.push('/settings/privacy')),
                      ]),
                      const SizedBox(height: 24),
                      _buildSignOutButton(context),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              _buildSectionHeader("Account"),
              _buildTile(Icons.person, "Edit Profile", "Name, Email, Phone", const Color(0xFF7C3AED), () => context.push('/settings/profile')),
              _buildTile(Icons.lock_person, "Security", "Password, Two-factor auth", Colors.amber, () => context.push('/settings/security')),
              _buildTile(Icons.payment, "Payment Methods", "Cards, UPI, Bank accounts", Colors.blue, () => context.push('/settings/payment')),
              
              const SizedBox(height: 32),
              _buildSectionHeader("Preferences"),
              _buildLanguageTile(context),
              _buildCurrencyTile(context),
              _buildTile(Icons.notifications, "Notifications", "Push, Email, SMS", Colors.orange, () => context.push('/settings/notifications')),
              
              const SizedBox(height: 32),
              _buildSectionHeader("Support & About"),
              _buildTile(Icons.help_center, "Help Center", "FAQs, Contact support", Colors.redAccent, () => context.push('/settings/help')),
              _buildTile(Icons.privacy_tip, "Privacy Policy", "Data usage and protection", Colors.blueAccent, () => context.push('/settings/privacy')),
              
              const SizedBox(height: 48),
              _buildSignOutButton(context),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: children.map((c) => SizedBox(width: 250, child: c)).toList(),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildDesktopTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color.withOpacity(0.8), size: 32),
            ),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
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
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color.withOpacity(0.8), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildTile(
          Icons.language,
          "Language",
          state.locale.languageCode == 'en' ? "English" : "Hindi (हिंदी)",
          Colors.cyan,
          () {},
        );
      },
    );
  }

  Widget _buildDesktopLanguageTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildDesktopTile(
          Icons.language,
          "Language",
          state.locale.languageCode == 'en' ? "English" : "Hindi (हिंदी)",
          Colors.cyan,
          () {},
        );
      },
    );
  }

  Widget _buildCurrencyTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildTile(
          Icons.currency_exchange,
          "Currency",
          state.currency,
          Colors.indigo,
          () {},
        );
      },
    );
  }

  Widget _buildDesktopCurrencyTile(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return _buildDesktopTile(
          Icons.currency_exchange,
          "Currency",
          state.currency,
          Colors.indigo,
          () {},
        );
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await context.read<AuthService>().signOut();
          if (context.mounted) context.go('/login');
        },
        child: const Text(
          "Sign Out",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
