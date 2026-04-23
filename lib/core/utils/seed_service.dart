import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/listing_model.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seeds listings from assets/data/sample_listings.json to Firestore
  Future<void> seedListings() async {
    try {
      print("[SeedService] Starting seed process...");
      final String response = await rootBundle.loadString('assets/data/sample_listings.json');
      final List<dynamic> data = json.decode(response);

      final batch = _firestore.batch();
      
      for (var item in data) {
        final listing = ListingModel.fromJson(item as Map<String, dynamic>);
        final listingDoc = _firestore.collection('listings').doc(listing.id);
        
        // Push listing data
        batch.set(listingDoc, {
          ...listing.toJson(),
          'owner_user_id': listing.ownerId, // Map owner_id
          'createdAt': FieldValue.serverTimestamp(),
          'is_available_for_rent': true, // Ensure they are rentable for prototype
          'price_rent_daily': listing.priceSale ?? 5.99, // Fallback rent price
        });

        // Generate 30 days of availability
        final availabilityCol = listingDoc.collection('availability');
        final now = DateTime.now();
        for (int i = 0; i < 30; i++) {
          final date = now.add(Duration(days: i));
          final dateStr = date.toIso8601String().split('T')[0];
          final availDoc = availabilityCol.doc(dateStr);
          batch.set(availDoc, {
            'available': true,
            'price': listing.priceSale ?? 5.99,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();
      print("[SeedService] Seed completed successfully for ${data.length} items.");
    } catch (e) {
      print("[SeedService] Seed failed: $e");
    }
  }
}
