import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import 'package:flippa/ui/widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [
    {
      "title": "Order Shipped!",
      "body": "Your order for 'Clean Code' has been shipped by the seller.",
      "time": "2h ago",
      "isRead": false,
      "type": "order",
    },
    {
      "title": "New Message",
      "body": "Pravin Gokul sent you a message regarding your rental.",
      "time": "5h ago",
      "isRead": false,
      "type": "message",
    },
    {
      "title": "Price Drop",
      "body": "An item in your wishlist 'The Pragmatic Programmer' is now 20% off!",
      "time": "1d ago",
      "isRead": true,
      "type": "promo",
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _notifications = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: const Color(0xFF1E1E2C)),
          onPressed: () => context.pop(),
        ),
        title: const Text("Notifications", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
        actions: [
          if (_notifications.isNotEmpty) ...[
            TextButton(
              onPressed: _markAllRead,
              child: const Text("Mark all as read", style: TextStyle(fontSize: 12)),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 20),
              onPressed: _clearAll,
            ),
          ],
        ],
      ),
      body: _notifications.isEmpty 
        ? const EmptyState(
            icon: Icons.notifications_off_outlined,
            title: "No notifications",
            message: "You're all caught up! When you get a new notification, it will appear here.",
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final n = _notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => setState(() => n['isRead'] = true),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypeIcon(n['type']),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(n['title'], style: TextStyle(fontWeight: n['isRead'] ? FontWeight.normal : FontWeight.bold, fontSize: 15)),
                                  if (!n['isRead'])
                                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(n['body'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              const SizedBox(height: 8),
                              Text(n['time'], style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'order': icon = Icons.local_shipping_outlined; color = Colors.blue; break;
      case 'message': icon = Icons.chat_bubble_outline; color = Colors.green; break;
      case 'promo': icon = Icons.local_offer_outlined; color = Colors.orange; break;
      default: icon = Icons.notifications_none; color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
