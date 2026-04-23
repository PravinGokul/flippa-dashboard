import 'package:flutter/material.dart';
import 'package:flippa/ui/widgets/glass/glass_card.dart';
import 'package:flippa/services/analytics/seller_analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerInsights extends StatelessWidget {
  const SellerInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsService = SellerAnalyticsService();
    final sellerId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    return FutureBuilder<Map<String, dynamic>>(
      future: analyticsService.getSellerMetrics(sellerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final metrics = snapshot.data!;
        final insights = analyticsService.generateInsights(metrics);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Growth Insights",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildMetricCard("Views", metrics['views'].toString(), Icons.visibility_outlined),
                  const SizedBox(width: 16),
                  _buildMetricCard("Bookings", metrics['bookings'].toString(), Icons.book_online_outlined),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMetricCard("Utilization", "${(metrics['utilizationRate'] * 100).toInt()}%", Icons.pie_chart_outline),
                  const SizedBox(width: 16),
                  _buildMetricCard("Response", "${metrics['avgResponseTimeMin']}m", Icons.timer_outlined),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
              ),
              const SizedBox(height: 16),
              ...insights.map((insight) => _buildInsightCard(insight)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(Map<String, String> insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: insight['impact'] == 'High' ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                insight['type'] == 'pricing' ? Icons.sell_outlined : Icons.lightbulb_outline,
                color: insight['impact'] == 'High' ? Colors.redAccent : Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight['message']!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E2C)),
                  ),
                  const SizedBox(height: 2),
                  Text("Impact: ${insight['impact']}", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
