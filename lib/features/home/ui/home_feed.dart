import 'package:flutter/material.dart';
import 'package:flippa/ui/widgets/glass/glass_card.dart';
import 'package:flippa/data/models/listing_model.dart';
import 'package:flippa/features/marketplace/listings/listing_card.dart';
import 'package:flippa/services/ai/recommendation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendationService = RecommendationService();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Recommended for You"),
          const SizedBox(height: 16),
          _buildHorizontalList(
            future: recommendationService.getRecommendations(userId: userId),
          ),
          const SizedBox(height: 40),
          _buildSectionTitle("Trending Near You"),
          const SizedBox(height: 16),
          _buildHorizontalList(
            future: recommendationService.getRecommendations(userId: userId),
          ),
          const SizedBox(height: 40),
          _buildSectionTitle("New Listings"),
          const SizedBox(height: 16),
          _buildHorizontalList(
            future: recommendationService.getRecommendations(userId: userId),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1E2C),
        ),
      ),
    );
  }

  Widget _buildHorizontalList({required Future<List<ListingModel>> future}) {
    return FutureBuilder<List<ListingModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 300,
            child: Center(child: Text("No items found")),
          );
        }

        return SizedBox(
          height: 320,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 220,
                child: ListingCard(listing: snapshot.data![index]),
              );
            },
          ),
        );
      },
    );
  }
}
