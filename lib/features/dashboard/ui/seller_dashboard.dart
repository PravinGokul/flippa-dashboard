import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../ui/widgets/glass/glass_card.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;
    
    if (sellerId == null) {
      return const Scaffold(body: Center(child: Text("Please login to view dashboard")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Seller Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E2C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("rentals")
            .where("sellerId", isEqualTo: sellerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rentals = snapshot.data?.docs ?? [];
          
          // Logic for KPI calculations
          final activeRentals = rentals.where((d) => (d.data() as Map)['status'] == 'active').length;
          final pendingInspections = rentals.where((d) => (d.data() as Map)['status'] == 'returned').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildKPICard(context, "Active Rentals", activeRentals.toString(), Icons.book_online, Colors.blue),
                    _buildKPICard(context, "Revenue", "\$0.00", Icons.monetization_on, Colors.green),
                    _buildKPICard(context, "Inspections", pendingInspections.toString(), Icons.assignment_turned_in, Colors.orange),
                    _buildKPICard(context, "Disputes", "0", Icons.gavel, Colors.red),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                ),
                const SizedBox(height: 16),
                if (rentals.isEmpty)
                  const GlassContainer(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text("No rental activity yet", style: TextStyle(color: Colors.grey))),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rentals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = rentals[index].data() as Map<String, dynamic>;
                      return _buildActivityTile(data);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKPICard(BuildContext context, String title, String value, IconData icon, Color color) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.1)),
        ],
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> data) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(Icons.history, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rental #${data['paymentIntentId']?.toString().substring(0, 8) ?? 'Unknown'}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Status: ${data['status']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
