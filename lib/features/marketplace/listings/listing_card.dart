import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/localization_utils.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/ui/theme/glass_theme.dart';
import 'package:flippa/core/utils/currency_service.dart';
import 'package:flippa/core/services/location_service.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;

  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/listing/${listing.id}', extra: listing),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: GlassContainer(
          padding: const EdgeInsets.all(12), // Outer glass padding
          blur: GlassTheme.blurStrong,
          background: GlassTheme.glassWhiteLow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Internal Book Cover Container (Nested Glass Layer)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 0.75, // Better fit for book covers
                    child: Image.network(
                      listing.imageUrls?.isNotEmpty == true ? listing.imageUrls!.first : 'https://via.placeholder.com/300x400',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.white10,
                        child: const Icon(Icons.book, color: Colors.white24, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800, 
                        fontSize: 14,
                        color: Color(0xFF1E1E2C), // Changed to dark for readability in light mode dashboard
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'by ${listing.author}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF1E1E2C).withOpacity(0.6), 
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    BlocBuilder<GlobalBloc, GlobalState>(
                      builder: (context, state) {
                        final rate = state.exchangeRate;
                        final currency = state.currency;
                        final sellingPrice = listing.priceSale ?? listing.priceRentDaily ?? 0.0;
                        
                        // Calculate distance if coordinates are available
                        String? distanceStr;
                        final listingsState = context.read<ListingsBloc>().state;
                        if (listingsState is ListingsLoaded && 
                            listingsState.userLat != null && 
                            listingsState.userLng != null &&
                            listing.latitude != null &&
                            listing.longitude != null) {
                          final dist = LocationService.calculateDistance(
                            listingsState.userLat!, 
                            listingsState.userLng!, 
                            listing.latitude!, 
                            listing.longitude!
                          );
                          distanceStr = LocationService.formatDistance(dist);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CurrencyService.format(sellingPrice, currency, exchangeRate: rate),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900, 
                                fontSize: 15,
                                color: Color(0xFF1E1E2C),
                              ),
                            ),
                            if (distanceStr != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  distanceStr,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

