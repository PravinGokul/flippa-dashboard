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

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          
          if (isDesktop) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
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
                                background: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02),
                                child: _buildAvatarInfo(context, initials, name, username),
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

                final isDark = Theme.of(context).brightness == Brightness.dark;
                final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHeaderButton(context, Icons.chevron_left, () => context.pop()),
                          Text("My Flippa", style: TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.bold)),
                          _buildHeaderButton(context, Icons.notifications_outlined, () {}),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildAvatarInfo(context, initials, name, username),
                      const SizedBox(height: 40),
                      ..._buildMenuItemsList(context),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAvatarInfo(BuildContext context, String initials, String name, String username) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final usernameColor = isDark ? Colors.white60 : const Color(0xFF64748B);

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
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
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
                  border: Border.all(color: isDark ? const Color(0xFF0F172A) : Colors.white, width: 2),
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
        Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: nameColor)),
        Text(username, style: TextStyle(fontSize: 14, color: usernameColor)),
      ],
    );
  }

  List<Widget> _buildDesktopMenuItemsList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return [
      _buildDesktopMenuItem(context, Icons.home_outlined, "My Listings", () => context.push('/my-listings'), color: defaultColor),
      _buildDesktopMenuItem(context, Icons.favorite_outline_rounded, "Saved Items", () {}, color: defaultColor),
      _buildDesktopMenuItem(context, Icons.list_alt_rounded, "Transactions", () {}, color: defaultColor),
      _buildDesktopMenuItem(context, Icons.chat_bubble_outline_rounded, "Messages", () {}, color: defaultColor),
      _buildDesktopMenuItem(context, Icons.insights_rounded, "Performance Stats", () {}, color: defaultColor),
      _buildDesktopMenuItem(context, Icons.settings_outlined, "Settings", () => context.push('/settings'), color: defaultColor),
      _buildDesktopMenuItem(context, Icons.help_outline_rounded, "Help Center", () {}, color: defaultColor),
      _buildDesktopMenuItem(context, Icons.logout_rounded, "Sign Out", () => FirebaseAuth.instance.signOut(), color: Colors.redAccent),
    ];
  }

  Widget _buildDesktopMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {required Color color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        background: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.4),
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
      _buildMenuItem(context, Icons.home_outlined, "My Listings", () => context.push('/my-listings')),
      _buildMenuItem(context, Icons.favorite_outline_rounded, "Saved Items", () {}),
      _buildMenuItem(context, Icons.list_alt_rounded, "Transactions", () {}),
      _buildMenuItem(context, Icons.chat_bubble_outline_rounded, "Messages", () {}),
      _buildMenuItem(context, Icons.insights_rounded, "Performance Stats", () {}),
      _buildMenuItem(context, Icons.settings_outlined, "Settings", () => context.push('/settings')),
      _buildMenuItem(context, Icons.help_outline_rounded, "Help Center", () {}),
      const SizedBox(height: 32),
      _buildSignOutButton(context),
      const SizedBox(height: 40),
    ];
  }


  Widget _buildHeaderButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF1E293B), size: 20),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final iconColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          background: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.4),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: titleColor),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: isDark ? Colors.white24 : const Color(0xFF94A3B8), size: 20),
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
