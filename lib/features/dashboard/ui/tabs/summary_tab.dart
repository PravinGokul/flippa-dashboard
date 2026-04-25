import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/currency_service.dart';
import '../../services/analytics/seller_analytics_service.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../widgets/revenue_chart.dart';

class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final analyticsService = SellerAnalyticsService();

    return FutureBuilder<Map<String, dynamic>>(
      future: analyticsService.getSellerMetrics(sellerId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final metrics = snapshot.data!;
        final insights = analyticsService.generateInsights(metrics);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Verification Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "My Dashboard",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                        ),
                        Row(
                          children: [
                            Text(
                              FirebaseAuth.instance.currentUser?.displayName ?? "Pravin Gokul",
                              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const Text(" • ", style: TextStyle(color: Color(0xFF64748B))),
                            const Text(
                              "Verified Seller",
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.check_box, color: Colors.green, size: 16),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text("KYC", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.check, size: 14, color: Colors.blueAccent),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Top Stats Grid (Primary Metrics)
                BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    final rate = state.exchangeRate;
                    final currency = state.currency;
                    final revenue = metrics['revenue']?.toDouble() ?? 5099.0;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        _buildStatCard("Active Rentals", "6", Icons.book_outlined, Colors.purple),
                        _buildStatCard("Revenue", CurrencyService.format(revenue, currency, exchangeRate: rate), Icons.attach_money, Colors.teal),
                        _buildStatCard("Inspections", "1", Icons.assignment_outlined, Colors.orange),
                        _buildStatCard("Disputes", "0", Icons.chat_bubble_outline, Colors.red),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                RevenueChart(metrics: metrics),
                const SizedBox(height: 32),

                const Text(
                  "Bookshelf Stats",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                ),
                const SizedBox(height: 16),
                
                // Secondary Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    _buildStatCard("Views", "1231", Icons.visibility_outlined, Colors.black),
                    _buildStatCard("Bookings", "76", Icons.calendar_today_outlined, Colors.indigo),
                    _buildStatCard("Utilization", "75%", Icons.bar_chart_rounded, Colors.green),
                    _buildStatCard("Response", "18m", Icons.bolt_rounded, Colors.orange),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  "Selling Mastery",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                ),
                const Text(
                  "Tips to boost your sales",
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                
                ...insights.map((insight) => _buildInsightCard(insight)).toList(),
                
                const SizedBox(height: 32),
                
                // Pro Tip Banner
                InkWell(
                  onTap: () => context.push('/kyc'),
                  borderRadius: BorderRadius.circular(20),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF1E1E2C),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Colors.amber, size: 32),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Go Pro!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("Verify your identity to unlock global shipping and lower platform fees.", 
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color.withOpacity(0.8), size: 24),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInsightCard(Map<String, String> insight) {
    final isHighImpact = insight['impact'] == 'High';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isHighImpact ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
              child: Icon(
                insight['type'] == 'pricing' ? Icons.sell_outlined : Icons.lightbulb_outline,
                color: isHighImpact ? Colors.redAccent : Colors.blueAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight['message']!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Impact: ${insight['impact']}", 
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isHighImpact ? Colors.redAccent : Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(test['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                        child: Text(test['variant'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text("Conv: ${test['conversion']}", style: const TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: test['status'] == 'Winning' ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                test['status'], 
                style: TextStyle(
                  color: test['status'] == 'Winning' ? Colors.green : Colors.blue, 
                  fontSize: 10, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
