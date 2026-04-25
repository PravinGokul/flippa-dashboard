import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/listing_model.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';

class AuctionListingScreen extends StatefulWidget {
  final ListingModel listing;
  const AuctionListingScreen({super.key, required this.listing});

  @override
  State<AuctionListingScreen> createState() => _AuctionListingScreenState();
}

class _AuctionListingScreenState extends State<AuctionListingScreen> {
  final TextEditingController _bidController = TextEditingController();
  double _currentBid = 850.0;
  bool _isBidding = false;

  final List<Map<String, dynamic>> _bidHistory = [
    {"name": "Ananya K.", "amount": 850.0, "time": "5m ago", "initials": "AK"},
    {"name": "Rahul M.", "amount": 800.0, "time": "12m ago", "initials": "RM"},
    {"name": "Priya S.", "amount": 750.0, "time": "1h ago", "initials": "PS"},
  ];

  @override
  void initState() {
    super.initState();
    _bidController.text = (_currentBid + 50).toStringAsFixed(0);
  }

  @override
  void dispose() {
    _bidController.dispose();
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
        title: const Text("Auction / Hybrid Mode", style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAuctionHeader(),
            const SizedBox(height: 32),
            _buildBiddingSection(),
            const SizedBox(height: 40),
            const Text("Bid History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
            const SizedBox(height: 16),
            _buildBidHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionHeader() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.gavel_rounded, color: Color(0xFF1E1E2C)),
                  SizedBox(width: 8),
                  Text("Live Auction", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.redAccent, size: 10),
                    SizedBox(width: 4),
                    Text("LIVE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.listing.imageUrls?.isNotEmpty == true ? widget.listing.imageUrls!.first : 'https://via.placeholder.com/60x80',
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.listing.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("by ${widget.listing.author}", style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Current Bid", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            Text("₹${_currentBid.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.green)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${_bidHistory.length} Bids", style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            const Text("Ends in 2h 45m", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orange)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiddingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Your Bid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: _bidController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text("₹", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              ),
              hintText: "Min ₹${(_currentBid + 50).toStringAsFixed(0)}",
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _isBidding
            ? const Center(child: CircularProgressIndicator())
            : GlassButton(
                label: "Place Bid - ₹${_bidController.text} →",
                onPressed: _handlePlaceBid,
                width: double.infinity,
                color: const Color(0xFF1E1E2C),
              ),
      ],
    );
  }

  Widget _buildBidHistory() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bidHistory.length,
      itemBuilder: (context, index) {
        final bid = _bidHistory[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF1F5F9),
                  child: Text(bid['initials'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(bid['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${bid['amount'].toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(bid['time'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePlaceBid() async {
    final amount = double.tryParse(_bidController.text);
    if (amount == null || amount <= _currentBid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bid must be greater than current bid (₹$_currentBid)")));
      return;
    }

    setState(() => _isBidding = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isBidding = false;
        _currentBid = amount;
        _bidHistory.insert(0, {
          "name": "You",
          "amount": amount,
          "time": "Just now",
          "initials": "YU"
        });
        _bidController.text = (_currentBid + 50).toStringAsFixed(0);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bid placed successfully!")));
    }
  }
}
