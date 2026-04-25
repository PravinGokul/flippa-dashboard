import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mockUsers = [
    {"name": "Pravin Gokul", "role": "Verified Seller", "status": "verified", "initials": "PG"},
    {"name": "Ananya K.", "role": "Buyer", "status": "warning", "initials": "AK"},
    {"name": "Rahul M.", "role": "Flagged", "status": "flagged", "initials": "RM"},
    {"name": "Priya S.", "role": "Verified Seller", "status": "verified", "initials": "PS"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
        title: const Text("User Management", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _mockUsers.length,
              itemBuilder: (context, index) {
                return _buildUserCard(_mockUsers[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search users...",
            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
            prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        labelColor: const Color(0xFF1E1E2C),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Sellers"),
          Tab(text: "Buyers"),
          Tab(text: "Flagged"),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    Color statusColor;
    IconData statusIcon;
    switch (user['status']) {
      case 'verified':
        statusColor = Colors.green;
        statusIcon = Icons.check_box;
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning_rounded;
        break;
      case 'flagged':
        statusColor = Colors.redAccent;
        statusIcon = Icons.error_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Text(user['initials'], style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E2C))),
                  Text(user['role'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                ],
              ),
            ),
            Icon(statusIcon, color: statusColor, size: 24),
            const SizedBox(width: 16),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: BottomNavigationBar(
        currentIndex: 4, // Admin tab
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E1E2C),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.go('/my-flippa');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dash'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
