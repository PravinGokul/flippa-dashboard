import 'package:flutter/material.dart';
import 'tabs/summary_tab.dart';
import 'tabs/selling_tab.dart';

class MyFlippaScreen extends StatelessWidget {
  const MyFlippaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          title: const Text('My Flippa', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E1E2C),
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Summary"),
              Tab(text: "Selling"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SummaryTab(),
            SellingTab(),
          ],
        ),
      ),
    );
  }
}
