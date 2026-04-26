import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/global_background.dart';
import 'dart:ui';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int getIndex() {
      if (location == '/') return 0;
      if (location.startsWith('/market')) return 1;
      if (location.startsWith('/dashboard')) return 2;
      if (location.startsWith('/my-flippa')) return 3;
      if (location.startsWith('/admin')) return 4;
      return 0;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return GlobalBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: isDesktop ? _buildDesktopHeader(context, getIndex()) : null,
            body: child,
            bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(context, getIndex()),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildDesktopHeader(BuildContext context, int currentIndex) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text("Flippa", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 24)),
                  const SizedBox(width: 40),
                  _headerNavButton(context, "Home", 0, currentIndex),
                  _headerNavButton(context, "Marketplace", 1, currentIndex),
                  _headerNavButton(context, "Dashboard", 2, currentIndex),
                  _headerNavButton(context, "My Flippa", 3, currentIndex),
                  if (currentIndex == 4) _headerNavButton(context, "Admin", 4, currentIndex),
                  const Spacer(),
                  const Icon(Icons.notifications_none, color: Color(0xFF64748B)),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFE2E8F0),
                    child: Icon(Icons.person, color: Color(0xFF94A3B8), size: 20),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.white.withOpacity(0.3), height: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerNavButton(BuildContext context, String label, int index, int currentIndex) {
    final isSelected = index == currentIndex;
    return TextButton(
      onPressed: () {
        switch (index) {
          case 0: context.go('/'); break;
          case 1: context.go('/market'); break;
          case 2: context.go('/dashboard'); break;
          case 3: context.go('/my-flippa'); break;
          case 4: context.go('/admin'); break;
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF64748B),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMobileBottomNav(BuildContext context, int currentIndex) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            border: Border(top: BorderSide(color: Colors.grey[200]!.withOpacity(0.5))),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0: context.go('/'); break;
                case 1: context.go('/market'); break;
                case 2: context.go('/dashboard'); break;
                case 3: context.go('/my-flippa'); break;
                case 4: context.go('/admin'); break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF7C3AED),
            unselectedItemColor: const Color(0xFF94A3B8),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Market'),
              BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'My Flippa'),
              BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), activeIcon: Icon(Icons.shield), label: 'Admin'),
            ],
          ),
        ),
      ),
    );
  }
}
