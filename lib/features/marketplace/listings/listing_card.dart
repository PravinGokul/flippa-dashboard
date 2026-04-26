import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/localization_utils.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/ui/theme/glass_theme.dart';
import 'package:flippa/core/utils/currency_service.dart';
import 'package:flippa/core/services/location_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flippa/features/marketplace/listings/listings_bloc.dart';
import 'package:flippa/features/marketplace/listings/listings_state.dart';
import 'package:flippa/ui/widgets/glass/glass_container.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;

  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/listing/${listing.id}', extra: listing),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Proximity Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 0.85,
                    child: Image.network(
                      listing.imageUrls?.isNotEmpty == true ? listing.imageUrls!.first : 'https://via.placeholder.com/300x400',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(Icons.book, color: Color(0xFFCBD5E1), size: 40),
                      ),
                    ),
                  ),
                ),
                // Proximity Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 10),
                        const SizedBox(width: 2),
                        Text(
                          _getDistanceText(),
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${listing.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            listing.rating?.toString() ?? "4.8",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                      BlocBuilder<GlobalBloc, GlobalState>(
                        builder: (context, state) {
                          final rate = state.exchangeRate;
                          final currency = state.currency;
                          final price = listing.priceSale ?? listing.priceRentDaily ?? 18.99;
                          return Text(
                            CurrencyService.format(price, currency, exchangeRate: rate),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E293B)),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDistanceText() {
    // Mocking distance for UI matching
    final distances = ["1.2 km away", "3.5 km away", "0.8 km away", "2.1 km away", "4.3 km away"];
    return distances[listing.id.hashCode % distances.length];
  }
}

