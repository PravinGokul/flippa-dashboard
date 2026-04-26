import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';
import 'package:flippa/ui/widgets/glass/glass_button.dart';

class EscrowContractScreen extends StatefulWidget {
  final ListingModel listing;

  const EscrowContractScreen({super.key, required this.listing});

  @override
  State<EscrowContractScreen> createState() => _EscrowContractScreenState();
}

class _EscrowContractScreenState extends State<EscrowContractScreen> {
  bool _termsAccepted = false;
  bool _isSigning = false;

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
        title: const Text("Escrow Contract", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContractHeader(),
            const SizedBox(height: 32),
            const Text("Terms of Escrow", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTermsBox(),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                  activeColor: const Color(0xFF1E1E2C),
                ),
                const Expanded(
                  child: Text(
                    "I agree to the terms and conditions of the Escrow Service and authorize the holding of funds.",
                    style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _isSigning
                ? const Center(child: CircularProgressIndicator())
                : GlassButton(
                    label: "Sign & Secure Funds",
                    onPressed: _termsAccepted ? () => _handleSignContract() : null,
                    width: double.infinity,
                    color: const Color(0xFF1E1E2C),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractHeader() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.verified_user_outlined, size: 48, color: Colors.blueAccent),
          const SizedBox(height: 16),
          const Text(
            "Secure Transaction Contract",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Order ID: #FL-8829-X",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const Divider(height: 32),
          _buildInfoRow("Seller", "Pravin Gokul"),
          _buildInfoRow("Buyer", "You"),
          _buildInfoRow("Item", widget.listing.title),
          _buildInfoRow("Amount", "₹${(widget.listing.priceSale ?? 0).toStringAsFixed(0)}"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildTermsBox() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const SingleChildScrollView(
        child: Text(
          "1. Purpose: The Escrow Service is designed to protect both buyer and seller. Funds are held in a secure account until the buyer confirms receipt of the item.\n\n"
          "2. Release of Funds: Funds will be released to the seller once the buyer marks the item as 'Received' and 'Inspected' or after 7 days of delivery confirmation if no dispute is filed.\n\n"
          "3. Dispute Resolution: If the item is not as described, the buyer may file a dispute. Funds will be held until the dispute is resolved by Flippa support.\n\n"
          "4. Fees: A non-refundable escrow fee of 2% is included in the total price.\n\n"
          "5. Delivery: Sellers must provide a valid tracking number within 48 hours of contract signing.",
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
        ),
      ),
    );
  }

  Future<void> _handleSignContract() async {
    setState(() => _isSigning = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSigning = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contract Signed! Funds Secured.")));
      context.go('/');
    }
  }
}
