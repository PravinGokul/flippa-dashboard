import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum EventType { view, search, rent, buy }

class EventTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logEvent({
    required EventType eventType,
    required String listingId,
    required String category,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('events').add({
        'userId': user.uid,
        'eventType': eventType.name,
        'listingId': listingId,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging event: $e');
    }
  }
}
