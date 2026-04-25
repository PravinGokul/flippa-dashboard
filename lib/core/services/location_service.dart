import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request permissions and get current position
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // We only need approximate location for proximity
    );
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) / 1000;
  }

  /// Get a human-readable distance string
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return "${(distanceKm * 1000).toInt()}m away";
    }
    return "${distanceKm.toStringAsFixed(1)}km away";
  }
}
