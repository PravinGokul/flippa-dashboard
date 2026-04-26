import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[100], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Last Updated: October 2025", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildSection("1. Data We Collect", 
              "We collect information that you provide directly to us, such as when you create an account, list a book, or communicate with other users.\n\n"
              "• Personal identifiers (Name, Email, Phone)\n"
              "• Transactional information\n"
              "• Location data (to show nearby books)"),
            _buildSection("2. How We Use Data", 
              "We use the collected data to provide, maintain, and improve our services, including processing transactions and personalizing your experience."),
            _buildSection("3. Data Sharing", 
              "We do not sell your personal data. We share information only with service providers involved in order fulfillment and payment processing."),
            _buildSection("4. Your Rights", 
              "You have the right to access, correct, or delete your personal data at any time through the 'Edit Profile' section of the app."),
            const SizedBox(height: 40),
            const Center(
              child: Text("Questions? Contact us at privacy@flippa.in", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.6)),
        ],
      ),
    );
  }
}
