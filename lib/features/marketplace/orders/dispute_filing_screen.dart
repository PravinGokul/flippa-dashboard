import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';

class DisputeFilingScreen extends StatefulWidget {
  final String orderId;
  const DisputeFilingScreen({super.key, required this.orderId});

  @override
  State<DisputeFilingScreen> createState() => _DisputeFilingScreenState();
}

class _DisputeFilingScreenState extends State<DisputeFilingScreen> {
  String _selectedReason = "Item not received";
  final _descriptionController = TextEditingController();
  bool _isFiling = false;

  final List<String> _reasons = [
    "Item not received",
    "Wrong edition/book delivered",
    "Damaged condition",
    "Incomplete item",
    "Other",
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
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
        title: const Text("File a Dispute", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 32),
            const Text("Reason for Dispute", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReasonDropdown(),
            const SizedBox(height: 32),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 32),
            const Text("Photo Evidence", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPhotoUploadArea(),
            const SizedBox(height: 48),
            _isFiling
                ? const Center(child: CircularProgressIndicator())
                : GlassButton(
                    label: "Submit Dispute",
                    onPressed: _handleSubmit,
                    width: double.infinity,
                    color: Colors.redAccent,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 32, color: Color(0xFF1E1E2C)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: ${widget.orderId}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Date: 22 Apr 2024", style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedReason,
          isExpanded: true,
          onChanged: (val) => setState(() => _selectedReason = val!),
          items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Please describe the issue in detail...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadArea() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
      ),
      child: InkWell(
        onTap: () {
          // Trigger image picker
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 32, color: Color(0xFF94A3B8)),
            SizedBox(height: 8),
            Text("Upload photos (max 5)", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please provide a description")));
      return;
    }
    setState(() => _isFiling = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isFiling = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dispute filed successfully. Support will contact you shortly.")));
      context.pop();
    }
  }
}
