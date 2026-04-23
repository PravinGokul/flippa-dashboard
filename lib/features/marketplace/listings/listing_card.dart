import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/localization_utils.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/ui/theme/glass_theme.dart';
import 'package:flippa/core/utils/localization_utils.dart';

import '../../../ui/widgets/glass/glass_container.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;

  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    listing.imageUrls?.first ?? 'https://via.placeholder.com/300x400',
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
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${listing.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6), 
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<GlobalBloc, GlobalState>(
                    builder: (context, state) {
                      final rate = state.exchangeRate;
                      final currency = state.currency;
                      final sellingPrice = (listing.priceSale ?? listing.priceRentDaily ?? 0.0) * rate;

                      return Text(
                        CurrencyService.formatPrice(sellingPrice, currency),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900, 
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

