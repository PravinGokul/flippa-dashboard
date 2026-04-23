import 'package:cloud_functions/cloud_functions.dart';

class AiPricingService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> suggestPrice({
    required String listingId,
    double marketMedian = 30.0,
  }) async {
    try {
      final result = await _functions.httpsCallable('suggestPrice').call({
        'listingId': listingId,
        'marketMedian': marketMedian,
      });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      print('Pricing Service Error: $e');
      return {
        'suggestedPrice': marketMedian * 1.2 * 1.1, // Fallback logic
        'confidence': "low",
        'explanation': "Fallback calculation due to service interruption.",
      };
    }
  }
}
