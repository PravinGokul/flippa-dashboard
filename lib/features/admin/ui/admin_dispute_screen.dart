import 'package:flutter/material.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class AdminDisputeScreen extends StatefulWidget {
  const AdminDisputeScreen({super.key});

  @override
  State<AdminDisputeScreen> createState() => _AdminDisputeScreenState();
}

class _AdminDisputeScreenState extends State<AdminDisputeScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _disputes = [
    {
      'id': 'RNT-4421',
      'reporter': 'usr_ananya_k',
      'date': 'Apr 20',
      'description': 'Book returned with water damage',
      'status': 'in review',
      'statusColor': Colors.orange,
    },
    {
      'id': 'RNT-3892',
      'reporter': 'usr_rahul_m',
      'date': 'Apr 18',
      'description': 'Did not receive the book within promised time',
      'status': 'open',
      'statusColor': Colors.amber,
    },
    {
      'id': 'RNT-5102',
      'reporter': 'usr_priya_s',
      'date': 'Apr 15',
      'description': 'Wrong edition delivered, expected 3rd but got 2nd',
      'status': 'resolved',
      'statusColor': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Panel', 
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF1E293B))
            ),
            Text(
              'Dispute Management', 
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)
            ),
          ],
        ),
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E2C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Stats Grid
            Row(
              children: [
                Expanded(child: _buildStatCard("3", "Total", Icons.assignment_outlined, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard("2", "Active", Icons.search, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard("1", "Resolved", Icons.check_box_outlined, Colors.green)),
              ],
            ),
            const SizedBox(height: 32),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Open', 'In Review', 'Resolved'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _selectedFilter = filter),
                      selectedColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF64748B),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent),
                      ),
                      elevation: isSelected ? 4 : 0,
                      shadowColor: Colors.black.withOpacity(0.1),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Dispute List
            ..._disputes.map((dispute) => _buildDisputeCard(dispute)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(Map<String, dynamic> dispute) {
    final isResolved = dispute['status'] == 'resolved';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rental ${dispute['id']}", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: dispute['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dispute['status'].toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: dispute['statusColor']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Reported by: ${dispute['reporter']} • ${dispute['date']}",
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            Text(
              dispute['description'],
              style: const TextStyle(fontSize: 15, color: Color(0xFF475569), height: 1.4),
            ),
            const SizedBox(height: 24),
            if (isResolved)
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Resolved", 
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFF1F5F9)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Dismiss", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Resolve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
