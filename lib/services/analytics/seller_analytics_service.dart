import 'package:cloud_firestore/cloud_firestore.dart';

class SellerAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getSellerMetrics(String sellerId) async {
    try {
      // In a real app, this would fetch from a /seller_metrics/{id} collection
      // updated by a background process. Here we'll return mock data based on listing counts.
      final listingsSnapshot = await _firestore
          .collection('listings')
          .where('ownerId', isEqualTo: sellerId)
          .get();

      int listingCount = listingsSnapshot.docs.length;
      
      return {
        'views': listingCount * 120,
        'bookings': (listingCount * 7.5).toInt(),
        'utilizationRate': 0.65,
        'avgResponseTimeMin': 15,
        'rankingPercentile': 85,
      };
    } catch (e) {
      print('Error fetching seller metrics: $e');
      return {};
    }
  }

  List<Map<String, String>> generateInsights(Map<String, dynamic> metrics) {
    List<Map<String, String>> insights = [];
    
    double utilization = metrics['utilizationRate'] ?? 0.0;
    if (utilization < 0.5) {
      insights.add({
        'type': 'pricing',
        'message': 'Lower price by 10% to increase bookings',
        'impact': 'High'
      });
    }

    int responseTime = metrics['avgResponseTimeMin'] ?? 0;
    if (responseTime > 30) {
      insights.add({
        'type': 'trust',
        'message': 'Improve response time to boost ranking',
        'impact': 'Medium'
      });
    }

    if (insights.isEmpty) {
      insights.add({
        'type': 'growth',
        'message': 'Your stats are looking great! Keep up the good work.',
        'impact': 'Low'
      });
    }

    return insights;
  }
}
