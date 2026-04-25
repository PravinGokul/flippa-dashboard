import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2C)),
          onPressed: () => context.pop(),
        ),
        title: const Text("Track Order", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32),
            const Text("Delivery Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
            const SizedBox(height: 24),
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildTrackingStep("Order Placed", "April 22, 10:00 AM", isCompleted: true, isFirst: true),
                  _buildTrackingStep("Processing", "April 22, 02:30 PM", isCompleted: true),
                  _buildTrackingStep("Shipped", "April 23, 09:15 AM", isCompleted: true),
                  _buildTrackingStep("Out for Delivery", "Estimated April 24", isActive: true),
                  _buildTrackingStep("Delivered", "Pending", isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.book, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: $orderId", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                const Text("Clean Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("by Robert C. Martin", style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                const SizedBox(height: 8),
                const Text("Est. Delivery: April 24", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, {bool isCompleted = false, bool isActive = false, bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : (isActive ? Colors.blueAccent : Colors.white),
                border: Border.all(color: isCompleted ? Colors.green : (isActive ? Colors.blueAccent : Colors.grey[300]!), width: 2),
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : (isActive ? const Icon(Icons.circle, size: 10, color: Colors.white) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal, fontSize: 16, color: isActive || isCompleted ? const Color(0xFF1E1E2C) : const Color(0xFF94A3B8))),
              Text(subtitle, style: TextStyle(fontSize: 12, color: const Color(0xFF64748B))),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
