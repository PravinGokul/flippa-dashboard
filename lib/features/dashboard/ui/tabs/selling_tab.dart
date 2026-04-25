import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippa/features/marketplace/listings/listings_bloc.dart';
import 'package:flippa/features/marketplace/listings/listings_state.dart';
import 'package:flippa/features/marketplace/listings/listings_event.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';
import 'package:flippa/features/marketplace/listings/edit_listing_dialog.dart';
import 'package:flippa/ui/widgets/shimmer_loader.dart';

class SellingTab extends StatelessWidget {
  const SellingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocBuilder<ListingsBloc, ListingsState>(
      builder: (context, state) {
        if (state is ListingsLoading) {
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: 5,
            itemBuilder: (_, __) => const InventorySkeleton(),
          );
        }
        
        List<ListingModel> myListings = [];
        if (state is ListingsLoaded) {
          myListings = state.listings.where((l) => l.ownerId == uid).toList();
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: myListings.isEmpty
                    ? _buildEmptyState(context)
                    : _buildInventoryList(context, myListings),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Inventory", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
              Text("Manage your listed books", style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddListingDialog(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add New"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No books listed yet", style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => _showAddListingDialog(context),
            child: const Text("List your first book"),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(BuildContext context, List<ListingModel> listings) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: listings.length,
      itemBuilder: (context, index) => _buildInventoryCard(context, listings[index]),
    );
  }

  Widget _buildInventoryCard(BuildContext context, ListingModel listing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                listing.imageUrls?.isNotEmpty == true ? listing.imageUrls!.first : 'https://via.placeholder.com/60x80',
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.book)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("by ${listing.author}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusBadge(listing.isAvailableForSale ? "For Sale" : "For Rent"),
                      const SizedBox(width: 8),
                      Text("₹${(listing.priceSale ?? listing.priceRentDaily ?? 0).toStringAsFixed(0)}", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showEditListingDialog(context, listing),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, listing),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  void _showAddListingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => EditListingDialog(
        onSave: (listing) {
          context.read<ListingsBloc>().add(AddListing(listing));
        },
      ),
    );
  }

  void _showEditListingDialog(BuildContext context, ListingModel listing) {
    showDialog(
      context: context,
      builder: (ctx) => EditListingDialog(
        listing: listing,
        onSave: (updated) {
          // In a real app we'd update in repo too
          context.read<ListingsBloc>().add(RemoveListing(listing.id));
          context.read<ListingsBloc>().add(AddListing(updated));
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ListingModel listing) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Listing?"),
        content: Text("Are you sure you want to remove '${listing.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context.read<ListingsBloc>().add(RemoveListing(listing.id));
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
