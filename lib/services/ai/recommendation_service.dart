import 'package:cloud_functions/cloud_functions.dart';
import '../../data/models/listing_model.dart';

class RecommendationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<ListingModel>> getRecommendations({
    required String userId,
    String? currentListingId,
  }) async {
    try {
      final result = await _functions.httpsCallable('recommendListings').call({
        'userId': userId,
        'currentListingId': currentListingId,
      });

      final List<dynamic> listingsData = result.data['listings'];
      
      return listingsData.map((data) {
        // Ensure ID is properly handled as the model expect it
        return ListingModel.fromJson(Map<String, dynamic>.from(data));
      }).toList();
      
    } catch (e) {
      print('Recommendation error: $e');
      return [];
    }
  }

  Future<List<ListingModel>> getSimilarBooks(ListingModel listing, String userId) async {
    return getRecommendations(
      userId: userId,
      currentListingId: listing.id,
    );
  }
}
