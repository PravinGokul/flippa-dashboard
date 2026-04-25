import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';

class ReturnFlowScreen extends StatefulWidget {
  final String orderId;
  const ReturnFlowScreen({super.key, required this.orderId});

  @override
  State<ReturnFlowScreen> createState() => _ReturnFlowScreenState();
}

class _ReturnFlowScreenState extends State<ReturnFlowScreen> {
  String _selectedReason = "Received wrong item";
  String _selectedCondition = "Unopened / Original Condition";
  bool _isSubmitting = false;

  final List<String> _reasons = [
    "Received wrong item",
    "Item damaged or defective",
    "Item not as described",
    "No longer needed",
    "Other",
  ];

  final List<String> _conditions = [
    "Unopened / Original Condition",
    "Opened but unused",
    "Used",
    "Damaged by buyer (Not eligible)",
  ];

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
        title: const Text("Return Item", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 32),
            const Text("Reason for Return", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDropdown(_reasons, _selectedReason, (val) => setState(() => _selectedReason = val!)),
            const SizedBox(height: 24),
            const Text("Item Condition", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDropdown(_conditions, _selectedCondition, (val) => setState(() => _selectedCondition = val!)),
            const SizedBox(height: 24),
            const Text("Upload Photos (Required for damage claims)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildPhotoUploadArea(),
            const SizedBox(height: 40),
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : GlassButton(
                    label: "Confirm Return Request",
                    onPressed: _handleSubmit,
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
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.book, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: ${widget.orderId}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                const Text("Clean Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("by Robert C. Martin", style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadArea() {
    return Container(
      width: double.infinity,
      height: 100,
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
            Icon(Icons.add_photo_alternate_outlined, size: 32, color: Color(0xFF94A3B8)),
            SizedBox(height: 8),
            Text("Tap to upload photos", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Return request submitted successfully.")));
      context.pop();
    }
  }
}
