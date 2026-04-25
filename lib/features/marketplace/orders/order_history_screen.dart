import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import 'package:flippa/ui/widgets/empty_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text("My Orders", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E1E2C),
          unselectedLabelColor: const Color(0xFF94A3B8),
          indicatorColor: const Color(0xFF1E1E2C),
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Delivered"),
            Tab(text: "Returned"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList("active"),
          _buildOrdersList("delivered"),
          _buildOrdersList("returned"),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    // In a real app, this would be fetched from a repository
    final List<Map<String, dynamic>> orders = []; 

    if (orders.isEmpty) {
      return EmptyState(
        icon: status == "returned" ? Icons.assignment_return_outlined : Icons.shopping_bag_outlined,
        title: status == "active" ? "No Active Orders" : (status == "delivered" ? "No Past Orders" : "No Returns"),
        message: status == "active" 
          ? "You don't have any orders in transit. Start shopping to fill this space!"
          : "Your history is empty. Your completed orders will appear here.",
        actionLabel: status == "active" ? "Browse Marketplace" : null,
        onAction: status == "active" ? () => context.go('/') : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.book, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ID: ${order['id']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              _buildStatusBadge(order['status']),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(order['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(order['author'], style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                          const SizedBox(height: 8),
                          Text("₹${order['price']}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order['date'], style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    Row(
                      children: [
                        if (status == "active") ...[
                          _buildActionButton("Track", () {
                            context.push('/track/${order['id']}');
                          }),
                        ] else if (status == "delivered") ...[
                          _buildActionButton("Return", () {
                            context.push('/return/${order['id']}');
                          }),
                          const SizedBox(width: 8),
                          _buildActionButton("Review", () {}),
                          const SizedBox(width: 8),
                          _buildActionButton("Dispute", () {
                            context.push('/dispute/${order['id']}');
                          }, color: Colors.redAccent),
                        ] else ...[
                          _buildActionButton("Details", () {}),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case "In Transit": color = Colors.blue; break;
      case "Completed": color = Colors.green; break;
      case "Processing": color = Colors.orange; break;
      case "Refunded": color = Colors.purple; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color ?? const Color(0xFF1E1E2C)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(color: color ?? const Color(0xFF1E1E2C), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
