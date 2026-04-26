import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
        title: const Text("Help Center", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(),
            const SizedBox(height: 32),
            _buildSectionHeader("Popular Categories"),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildCategoryCard(Icons.rocket_launch_rounded, "Getting Started", Colors.blue),
                _buildCategoryCard(Icons.payment_rounded, "Payments", Colors.green),
                _buildCategoryCard(Icons.local_shipping_rounded, "Shipping", Colors.orange),
                _buildCategoryCard(Icons.assignment_return_rounded, "Returns", Colors.redAccent),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader("Top FAQs"),
            _buildFAQTile("How do I list a book?"),
            _buildFAQTile("What is the Escrow service?"),
            _buildFAQTile("How to track my order?"),
            const SizedBox(height: 40),
            _buildContactSupport(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFF64748B)),
          border: InputBorder.none,
          hintText: "Search for help...",
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
            const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text("Still need help?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Our support team is available 24/7.", style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E293B),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Chat with Us", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
