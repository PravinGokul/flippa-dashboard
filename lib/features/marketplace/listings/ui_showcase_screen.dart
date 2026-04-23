import 'package:flutter/material.dart';
import '../../../ui/widgets/glass/glass_card.dart';
import '../../../ui/widgets/glass/glass_button.dart';
import '../../../ui/widgets/glass/glass_app_bar.dart';

class UIShowcaseScreen extends StatelessWidget {
  const UIShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: const Text(
          'FLIPPA DESIGN SYSTEM',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D), Color(0xFF1E1E2C)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Glass Style 1',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is the base glass card used for listings and dashboard tiles. It supports nice blur and translucent borders.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 32),
                        const SizedBox(height: 8),
                        Text('Sale', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassCard(
                    child: Column(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 32),
                        const SizedBox(height: 8),
                        Text('Rent', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GlassButton(
              label: 'EXPLORE MARKETPLACE',
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            const GlassCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text('John Doe'),
                subtitle: Text('Pro Seller • 4.9 ★'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
