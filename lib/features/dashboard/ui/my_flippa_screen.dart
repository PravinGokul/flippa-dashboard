import 'package:flutter/material.dart';
import 'tabs/profile_tab.dart';
import '../../marketplace/orders/order_history_screen.dart';

class MyFlippaScreen extends StatelessWidget {
  const MyFlippaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2, // Default to Profile as per mock focus
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Flippa', 
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Color(0xFF1E293B))
              ),
              Text(
                'Your library & orders', 
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)
              ),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E1E2C),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TabBar(
                labelColor: const Color(0xFF7C3AED),
                unselectedLabelColor: const Color(0xFF64748B),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: "Orders"),
                  Tab(text: "Wishlist"),
                  Tab(text: "Profile"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            OrderHistoryScreen(), // This is a full screen, might need to extract the list part
            Center(child: Text("Wishlist is empty")),
            ProfileTab(),
          ],
        ),
      ),
    );
  }
}
