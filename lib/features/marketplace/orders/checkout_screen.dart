import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/listing_model.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';

class CheckoutScreen extends StatefulWidget {
  final ListingModel listing;

  const CheckoutScreen({super.key, required this.listing});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = "UPI";
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.listing.priceSale ?? 0.0;
    final fee = subtotal * 0.05; // 5% marketplace fee
    final total = subtotal + fee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2C)),
          onPressed: () => context.pop(),
        ),
        title: const Text("Checkout", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32),
            const Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
            const SizedBox(height: 16),
            _buildPaymentMethodOption("UPI", "Pay via Google Pay, PhonePe, etc.", Icons.account_balance_wallet_outlined),
            const SizedBox(height: 12),
            _buildPaymentMethodOption("Credit / Debit Card", "Visa, Mastercard, RuPay", Icons.credit_card_outlined),
            const SizedBox(height: 12),
            _buildPaymentMethodOption("Escrow Service", "Secure payment held until delivery", Icons.security_outlined),
            const SizedBox(height: 32),
            _buildPriceBreakdown(subtotal, fee, total),
            const SizedBox(height: 40),
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : GlassButton(
                    label: "Complete Purchase - ₹${total.toStringAsFixed(0)}",
                    onPressed: _handleCheckout,
                    width: double.infinity,
                    color: const Color(0xFF1E1E2C),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.listing.imageUrls?.first ?? 'https://via.placeholder.com/100x140',
              width: 80,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.listing.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("by ${widget.listing.author}", style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: const Text("In Stock", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, String subtitle, IconData icon) {
    bool isSelected = _selectedPaymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1E1E2C) : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF1E1E2C) : const Color(0xFF94A3B8)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1E1E2C), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(double subtotal, double fee, double total) {
    return Column(
      children: [
        _buildPriceRow("Subtotal", subtotal),
        const SizedBox(height: 8),
        _buildPriceRow("Marketplace Fee (5%)", fee),
        const Divider(height: 32),
        _buildPriceRow("Total", total, isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? const Color(0xFF1E1E2C) : const Color(0xFF64748B), fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(
          "₹${price.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: const Color(0xFF1E1E2C),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCheckout() async {
    setState(() => _isProcessing = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isProcessing = false);
      if (_selectedPaymentMethod == "Escrow Service") {
        context.push('/escrow-contract', extra: widget.listing);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchase Successful!")));
        context.go('/');
      }
    }
  }
}
