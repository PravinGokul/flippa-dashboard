import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => context.pop(),
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
        title: const Text("Payment Methods", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildCreditCard("4482 9910 8821 0092", "PETER GRANT", "12/26", const [Color(0xFF1E293B), Color(0xFF334155)]),
          const SizedBox(height: 16),
          _buildCreditCard("5591 2281 0019 3381", "PETER GRANT", "08/25", const [Color(0xFF7C3AED), Color(0xFF4C1D95)]),
          const SizedBox(height: 32),
          _buildSectionHeader("Other Methods"),
          _buildPaymentTile(Icons.account_balance_rounded, "Bank Account", "HDFC Bank **** 9921", Colors.blue),
          _buildPaymentTile(Icons.qr_code_2_rounded, "UPI ID", "peter.grant@okaxis", Colors.purple),
          const SizedBox(height: 32),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildCreditCard(String number, String name, String expiry, List<Color> colors) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.credit_card_rounded, color: Colors.white, size: 32),
              Text(number.startsWith('4') ? "VISA" : "Mastercard", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, fontStyle: FontStyle.italic)),
            ],
          ),
          Text(number, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w500)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CARD HOLDER", style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("EXPIRES", style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text(expiry, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: Color(0xFFE2E8F0)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1E293B), size: 20),
          SizedBox(width: 12),
          Text("Add New Payment Method", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
