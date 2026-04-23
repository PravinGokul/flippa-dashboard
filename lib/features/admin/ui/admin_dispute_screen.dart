import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippa/l10n/app_localizations.dart';
import 'package:flippa/ui/widgets/glass/glass_card.dart';
import 'package:flippa/data/models/dispute_model.dart';
import 'package:intl/intl.dart';

class AdminDisputeScreen extends StatelessWidget {
  const AdminDisputeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.adminDashboard),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E1E2C),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              l10n.activeDisputes,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('disputes')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No active disputes"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    data['id'] = snapshot.data!.docs[index].id;
                    final dispute = DisputeModel.fromJson(data);
                    return _buildDisputeCard(context, dispute, l10n);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(BuildContext context, DisputeModel dispute, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rental ID: ${dispute.rentalId}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildStatusChip(dispute.status, l10n),
              ],
            ),
            const SizedBox(height: 12),
            Text("${l10n.reason}: ${dispute.reason}"),
            const SizedBox(height: 8),
            Text("Reporter ID: ${dispute.reporterId}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _handleAction(dispute.id, 'dismissed'),
                  child: Text(l10n.dismiss, style: const TextStyle(color: Colors.redAccent)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleAction(dispute.id, 'resolved'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2C), foregroundColor: Colors.white),
                  child: Text(l10n.resolve),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, AppLocalizations l10n) {
    Color color;
    switch (status) {
      case 'resolved':
        color = Colors.green;
        break;
      case 'dismissed':
        color = Colors.red;
        break;
      case 'in_review':
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _handleAction(String disputeId, String newStatus) async {
    await FirebaseFirestore.instance.collection('disputes').doc(disputeId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
