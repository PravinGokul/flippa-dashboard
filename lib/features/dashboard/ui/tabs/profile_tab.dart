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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                children: [
                  // App Bar Style Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderButton(Icons.chevron_left, () => context.pop()),
                      const Text(
                        "My Flippa",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _buildHeaderButton(Icons.notifications_outlined, () {}),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Avatar & Info
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
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
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
                              Text(
                                "Verified Seller",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    username,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 40),

                  // Menu Items
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
                ],
              ),
            ),
          ),
          ),
          ),
        ],
      ),
    );
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
