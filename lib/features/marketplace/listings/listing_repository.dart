import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/listing_model.dart';

class ListingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Environment Gate (Pattern B/C)
  // In a real app, this would come from a Config or Env service
  static const bool isDemoMode = true;

  Future<List<ListingModel>> getListings() async {
    if (isDemoMode) {
      return _getDemoListings();
    } else {
      return _getProductionListings();
    }
  }

  Future<List<ListingModel>> _getDemoListings() async {
    try {
      final String response = await rootBundle.loadString('assets/data/sample_listings.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ListingModel.fromJson(json)).toList();
    } catch (e) {
      print("Error loading demo listings: $e");
      return [];
    }
  }

  Future<List<ListingModel>> _getProductionListings() async {
    try {
      final snapshot = await _firestore.collection('listings').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ListingModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error loading production listings: $e");
      return [];
    }
  }
}
