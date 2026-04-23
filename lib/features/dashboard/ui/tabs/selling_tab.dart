import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/data/repositories/listings_repository.dart';
import 'package:flippa/ui/widgets/glass/glass_card.dart';
import 'package:flippa/features/marketplace/listings/edit_listing_dialog.dart';

class SellingTab extends StatefulWidget {
  const SellingTab({super.key});

  @override
  State<SellingTab> createState() => _SellingTabState();
}

class _SellingTabState extends State<SellingTab> {
  final _repo = ListingsRepository();
  late Future<List<ListingModel>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _listingsFuture = _repo.getListingsByOwner(uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListingModel>>(
      future: _listingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final listings = snapshot.data ?? [];
        if (listings.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildInventoryList(listings);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.library_add_outlined, size: 52, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Books Listed Yet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Start selling by listing your first book from the marketplace.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryList(List<ListingModel> listings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Text(
                "${listings.length} Active Listings",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 8),
                    SizedBox(width: 6),
                    Text("Active", style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: listings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildInventoryTile(context, listings[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTile(BuildContext context, ListingModel listing) {
    final imageUrl = listing.imageUrls?.isNotEmpty == true ? listing.imageUrls!.first : null;
    final price = listing.priceSale;

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null
                ? Image.network(imageUrl, width: 60, height: 75, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderThumbnail())
                : _placeholderThumbnail(),
          ),
          const SizedBox(width: 14),
          // Title & Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E2C)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "by ${listing.author}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (price != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Text(
                          "₹${price.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                      ),
                    if (listing.isAvailableForRent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Text("Rent", style: TextStyle(fontSize: 11, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                      ),
                    ],
                    if (listing.isAvailableForSale) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                        ),
                        child: const Text("Sale", style: TextStyle(fontSize: 11, color: Colors.deepOrange, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Quick Actions
          Column(
            children: [
              _actionButton(Icons.edit_outlined, Colors.blueAccent, () async {
                final didUpdate = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => EditListingDialog(listing: listing),
                );
                
                if (didUpdate == true) {
                  setState(() {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    _listingsFuture = _repo.getListingsByOwner(uid);
                  });
                }
              }),
              const SizedBox(height: 8),
              _actionButton(Icons.delete_outline, Colors.redAccent, () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Listing?"),
                    content: Text("Are you sure you want to remove \"${listing.title}\"?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await _repo.deleteListing(listing.id);
                  setState(() {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    _listingsFuture = _repo.getListingsByOwner(uid);
                  });
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: 60,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.menu_book_outlined, color: Colors.grey, size: 28),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
