import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Uploads an image file to Firebase Storage and returns the download URL
  Future<String> uploadListingImage(XFile file) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User must be logged in to upload images");

    try {
      final fileName = const Uuid().v4();
      final extension = file.name.split('.').last;
      final fullPath = 'listings/$userId/$fileName.$extension';
      
      final ref = _storage.ref().child(fullPath);

      // Support for Web: use putData instead of putFile
      UploadTask uploadTask;
      if (kIsWeb) {
        final Uint8List bytes = await file.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/$extension'),
        );
      } else {
        // Fallback or handle mobile normally with putData using readAsBytes anyway 
        // to avoid dart:io dependency issues on web.
        final Uint8List bytes = await file.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/$extension'),
        );
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;

    } catch (e) {
      debugPrint("Error uploading image: $e");
      throw Exception("Failed to upload image.");
    }
  }

  /// Deletes an image from storage using its URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      // In a real app, parse the URL to get the path properly, 
      // or store the path in Firestore alongside the URL.
      if (imageUrl.contains('firebasestorage')) {
        final ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }
    } catch (e) {
      debugPrint("Error deleting image: $e");
    }
  }
}
