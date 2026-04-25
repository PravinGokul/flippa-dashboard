import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/location_service.dart';

class PaginatedListings {
  final List<ListingModel> listings;
  final dynamic lastCursor;
  final bool hasMore;

  PaginatedListings({
    required this.listings,
    required this.lastCursor,
    required this.hasMore,
  });
}

class ListingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'listings';
  final CacheService _cacheService = CacheService();

  // Environment Gate (Pattern A - Seed-once/Demo)
  // Set to true to show deterministic investor-grade sample data
  static const bool isDemoMode = true; // Enabled for testing proximity

  /// Fetch listings near a specific location
  Future<PaginatedListings> getListingsNearLocation({
    required double latitude,
    required double longitude,
    int limit = 10,
    dynamic lastCursor,
  }) async {
    if (isDemoMode) {
      return _getDemoListings(
        limit: limit, 
        offset: lastCursor as int? ?? 0,
        userLat: latitude,
        userLng: longitude,
      );
    }
    
    // In production, we would use geohash-based queries with GeoFlutterFire
    // For now, we fallback to standard pagination
    return getListings(limit: limit, lastCursor: lastCursor);
  }

  /// Fetch listings with pagination
  Future<PaginatedListings> getListings({
    int limit = 10,
    dynamic lastCursor,
  }) async {
    if (isDemoMode) {
      return _getDemoListings(limit: limit, offset: lastCursor as int? ?? 0);
    }
    
    try {
      Query query = _firestore.collection(_collection)
          .orderBy('created_at', descending: true)
          .limit(limit);

      if (lastCursor != null && lastCursor is DocumentSnapshot) {
        query = query.startAfterDocument(lastCursor);
      }

      final snapshot = await query.get();
      final listings = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ListingModel.fromJson(data);
      }).toList();

      // Production Hardening: Cache the first page for offline access
      if (lastCursor == null && listings.isNotEmpty) {
        final jsonData = json.encode(listings.map((l) => l.toJson()).toList());
        await _cacheService.saveCompressed('listings_offline_cache', jsonData);
      }

      return PaginatedListings(
        listings: listings,
        lastCursor: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: listings.length == limit,
      );
    } catch (e) {
      // Production Hardening: Offline Fallback
      if (lastCursor == null) {
        print("[ListingsRepository] Network error, attempting to load from Gzip cache...");
        final cachedData = await _cacheService.readDecompressed('listings_offline_cache');
        if (cachedData != null) {
          final List<dynamic> list = json.decode(cachedData);
          final listings = list.map((j) => ListingModel.fromJson(j)).toList();
          return PaginatedListings(
            listings: listings,
            lastCursor: null,
            hasMore: false,
          );
        }
      }
      rethrow;
    }
  }

  /// Stream of listings for real-time updates (Maintains 1st page only in this pattern)
  Stream<List<ListingModel>> getListingsStream() {
    if (isDemoMode) {
      return Stream.fromFuture(_getDemoListings(limit: 20, offset: 0).then((p) => p.listings));
    }

    return _firestore.collection(_collection).orderBy('createdAt', descending: true).limit(20).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ListingModel.fromJson(data);
      }).toList();
    });
  }

  Future<PaginatedListings> _getDemoListings({
    required int limit, 
    required int offset,
    double? userLat,
    double? userLng,
  }) async {
    try {
      final String response = await rootBundle.loadString('assets/data/sample_listings.json');
      List<dynamic> allData = json.decode(response);
      
      List<ListingModel> allListings = allData.map((json) => ListingModel.fromJson(json)).toList();

      // Proximity Sorting
      if (userLat != null && userLng != null) {
        allListings.sort((a, b) {
          if (a.latitude == null || a.longitude == null) return 1;
          if (b.latitude == null || b.longitude == null) return -1;
          
          final distA = LocationService.calculateDistance(userLat, userLng, a.latitude!, a.longitude!);
          final distB = LocationService.calculateDistance(userLat, userLng, b.latitude!, b.longitude!);
          return distA.compareTo(distB);
        });
      }

      final int start = offset;
      final int end = (start + limit) > allListings.length ? allListings.length : (start + limit);
      
      if (start >= allListings.length) {
        return PaginatedListings(listings: [], lastCursor: offset, hasMore: false);
      }

      final listings = allListings.sublist(start, end);
      
      return PaginatedListings(
        listings: listings,
        lastCursor: end,
        hasMore: end < allListings.length,
      );
    } catch (e) {
      print("Error loading demo listings: $e");
      return PaginatedListings(listings: [], lastCursor: 0, hasMore: false);
    }
  }

  /// Fetch all listings for a specific seller (My Flippa - Selling Tab)
  Future<List<ListingModel>> getListingsByOwner(String ownerId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('owner_id', isEqualTo: ownerId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ListingModel.fromJson(data);
    }).toList();
  }

  /// Create a new listing
  Future<void> createListing(ListingModel listing) async {
    if (isDemoMode) return; // Prevent writes in demo mode
    
    final data = listing.toJson();
    data.remove('id'); // ID is generated by Firestore
    data['createdAt'] = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).add(data);
  }

  /// Update an existing listing
  Future<void> updateListing(ListingModel listing) async {
    if (isDemoMode) return;
    
    final data = listing.toJson();
    data.remove('id'); 
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).doc(listing.id).update(data);
  }

  /// Delete a listing
  Future<void> deleteListing(String id) async {
    if (isDemoMode) return;
    await _firestore.collection(_collection).doc(id).delete();
  }
}
