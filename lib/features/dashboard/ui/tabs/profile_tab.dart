import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? "Peter Grant";
    final username = "@${name.toLowerCase().replaceAll(' ', '_')}";
    final initials = name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark background matching mockup 3
      ),
      child: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                
                if (isDesktop) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GlassContainer(
                                padding: const EdgeInsets.all(32),
                                background: Colors.white.withOpacity(0.02),
                                child: _buildAvatarInfo(initials, name, username),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 24,
                                  runSpacing: 24,
                                  children: _buildDesktopMenuItemsList(context).map((c) => SizedBox(width: 200, child: c)).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHeaderButton(Icons.chevron_left, () => context.pop()),
                          const Text("My Flippa", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          _buildHeaderButton(Icons.notifications_outlined, () {}),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildAvatarInfo(initials, name, username),
                      const SizedBox(height: 40),
                      ..._buildMenuItemsList(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarInfo(String initials, String name, String username) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF334155), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Center(
                child: Text(initials, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F172A), width: 2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: Color(0xFF0F172A)),
                    SizedBox(width: 4),
                    Text("Verified Seller", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(username, style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8))),
      ],
    );
  }

  List<Widget> _buildDesktopMenuItemsList(BuildContext context) {
    return [
      _buildDesktopMenuItem(Icons.home_outlined, "My Listings", () => context.push('/my-listings')),
      _buildDesktopMenuItem(Icons.favorite_outline_rounded, "Saved Items", () {}),
      _buildDesktopMenuItem(Icons.list_alt_rounded, "Transactions", () {}),
      _buildDesktopMenuItem(Icons.chat_bubble_outline_rounded, "Messages", () {}),
      _buildDesktopMenuItem(Icons.insights_rounded, "Performance Stats", () {}),
      _buildDesktopMenuItem(Icons.settings_outlined, "Settings", () => context.push('/settings')),
      _buildDesktopMenuItem(Icons.help_outline_rounded, "Help Center", () {}),
      _buildDesktopMenuItem(Icons.logout_rounded, "Sign Out", () => FirebaseAuth.instance.signOut(), color: Colors.redAccent),
    ];
  }

  Widget _buildDesktopMenuItem(IconData icon, String title, VoidCallback onTap, {Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        background: Colors.white.withOpacity(0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItemsList(BuildContext context) {
    return [
      _buildMenuItem(Icons.home_outlined, "My Listings", () => context.push('/my-listings')),
      _buildMenuItem(Icons.favorite_outline_rounded, "Saved Items", () {}),
      _buildMenuItem(Icons.list_alt_rounded, "Transactions", () {}),
      _buildMenuItem(Icons.chat_bubble_outline_rounded, "Messages", () {}),
      _buildMenuItem(Icons.insights_rounded, "Performance Stats", () {}),
      _buildMenuItem(Icons.settings_outlined, "Settings", () => context.push('/settings')),
      _buildMenuItem(Icons.help_outline_rounded, "Help Center", () {}),
      const SizedBox(height: 32),
      _buildSignOutButton(context),
      const SizedBox(height: 40),
    ];
  }


  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          background: Colors.white.withOpacity(0.05),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return InkWell(
      onTap: () => FirebaseAuth.instance.signOut(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent.withOpacity(0.1), Colors.redAccent.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 12),
            Text(
              "Sign Out",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
