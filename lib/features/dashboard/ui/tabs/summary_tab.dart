import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';
import '../widgets/revenue_chart.dart';

class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildStatsGrid(),
          const SizedBox(height: 32),
          _buildRevenueSection(),
          const SizedBox(height: 32),
          _buildRecentActivity(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Dashboard",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(FirebaseAuth.instance.currentUser?.displayName ?? "Pravin Gokul", 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.circle, size: 4, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                const Text("Verified Seller", style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 14),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.1)),
          ),
          child: const Row(
            children: [
              Text("KYC", style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(width: 4),
              Icon(Icons.check, color: Color(0xFF3B82F6), size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final isTablet = constraints.maxWidth > 600 && !isDesktop;
        final count = isDesktop ? (constraints.maxWidth ~/ 250).clamp(2, 8) : (isTablet ? 3 : 2);
        
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.15, // Fixed to prevent bottom overflow
          children: [
            _buildStatCard("Active Rentals", "14", "+3%", Icons.home_rounded, Colors.purple),
            _buildStatCard("Total Revenue", "\$48,650", null, Icons.monetization_on_rounded, Colors.teal),
            _buildStatCard("Seller Rating", "4.9", "112 Reviews", Icons.star_rounded, Colors.amber),
            _buildStatCard("Active Guests", "19", "-1%", Icons.people_rounded, Colors.blue),
          ],
        );
      }
    );
  }

  Widget _buildStatCard(String title, String value, String? trend, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null && !trend.contains('Reviews'))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trend.startsWith('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trend.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 10,
                        color: trend.startsWith('+') ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend.replaceAll('+', '').replaceAll('-', ''),
                        style: TextStyle(
                          color: trend.startsWith('+') ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(
                title, 
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (trend != null && trend.contains('Reviews'))
                Text(
                  trend,
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 10, fontWeight: FontWeight.w500),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueSection() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Revenue Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text("Last 30 Days", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const SizedBox(
            height: 200,
            child: RevenueChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        _buildActivityItem(Icons.calendar_today_rounded, "New Booking", "2 mins ago", Colors.blue),
        _buildActivityItem(Icons.payments_rounded, "Payment Received", "45 mins ago", Colors.green),
        _buildActivityItem(Icons.person_pin_rounded, "Guest Check-in", "2 hours ago", Colors.orange),
      ],
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                  Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE2E8F0)),
          ],
        ),
      ),
    );
  }
}
