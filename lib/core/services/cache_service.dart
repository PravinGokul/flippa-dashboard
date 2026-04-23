import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  /// Save data to local storage with GZip compression
  Future<void> saveCompressed(String key, String data) async {
    if (kIsWeb) return; // dart:io not supported on web
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$key.gz');
      final bytes = utf8.encode(data);
      final compressed = gzip.encode(bytes);
      await file.writeAsBytes(compressed);
    } catch (e) {
      debugPrint("[CacheService] Error saving compressed data: $e");
    }
  }

  /// Read data from local storage and decompress
  Future<String?> readDecompressed(String key) async {
    if (kIsWeb) return null; // dart:io not supported on web

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$key.gz');
      if (!await file.exists()) return null;
      
      final compressed = await file.readAsBytes();
      final decompressed = gzip.decode(compressed);
      return utf8.decode(decompressed);
    } catch (e) {
      debugPrint("[CacheService] Error reading decompressed data: $e");
      return null;
    }
  }

  /// Clear specific cache item
  Future<void> clear(String key) async {
    if (kIsWeb) return; // dart:io not supported on web

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$key.gz');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint("[CacheService] Error clearing cache: $e");
    }
  }
}
