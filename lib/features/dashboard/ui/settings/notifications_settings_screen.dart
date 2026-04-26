import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _orderUpdates = true;
  bool _priceDrops = false;

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
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Channels"),
          _buildToggleTile(Icons.notifications_active_rounded, "Push Notifications", "Instant alerts on your device", Colors.blue, _pushEnabled, (val) => setState(() => _pushEnabled = val)),
          _buildToggleTile(Icons.alternate_email_rounded, "Email Notifications", "Weekly summaries and receipts", Colors.purple, _emailEnabled, (val) => setState(() => _emailEnabled = val)),
          
          const SizedBox(height: 32),
          _buildSectionHeader("Activity Alerts"),
          _buildToggleTile(Icons.local_shipping_rounded, "Order Updates", "Tracking and delivery status", Colors.green, _orderUpdates, (val) => setState(() => _orderUpdates = val)),
          _buildToggleTile(Icons.trending_down_rounded, "Price Drops", "Alerts for saved items", Colors.redAccent, _priceDrops, (val) => setState(() => _priceDrops = val)),
          
          const SizedBox(height: 32),
          _buildSectionHeader("Newsletter"),
          _buildToggleTile(Icons.auto_awesome_rounded, "Personalized Recommendations", "Based on your reading history", Colors.amber, true, (val) {}),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, Color color, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1E293B),
            ),
          ],
        ),
      ),
    );
  }
}
