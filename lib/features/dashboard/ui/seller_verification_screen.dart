import 'package:flutter/material.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerVerificationScreen extends StatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  State<SellerVerificationScreen> createState() => _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen> {
  bool _isSubmitting = false;

  Future<void> _submitVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);
    
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'role': 'seller', // Enforced as requested, though usually 'kycSubmitted' first
        'kycSubmitted': true,
        'verificationRequestedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Become a Seller', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E2C),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: GlassContainer(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 64, color: Colors.blueAccent),
                  const SizedBox(height: 24),
                  const Text(
                    "Professional Seller Verification",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "To start listing your books for sale, rent, or auction, we need to verify your identity. This ensures a safe environment for all BookMarket members.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6B7280), height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildRequirementItem(Icons.badge_outlined, "Government Issued ID"),
                  const SizedBox(height: 12),
                  _buildRequirementItem(Icons.home_work_outlined, "Proof of Address"),
                  const SizedBox(height: 12),
                  _buildRequirementItem(Icons.contact_mail_outlined, "Contact Information"),
                  const SizedBox(height: 48),
                  _isSubmitting
                      ? const CircularProgressIndicator()
                      : GlassButton(
                          label: "Submit for Review",
                          onPressed: _submitVerification,
                          width: double.infinity,
                        ),
                  const SizedBox(height: 16),
                  const Text(
                    "Verification typically takes 24-48 hours.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E1E2C), size: 24),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
          const Spacer(),
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
        ],
      ),
    );
  }
}
