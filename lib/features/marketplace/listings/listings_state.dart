import '../../../data/models/listing_model.dart';

abstract class ListingsState {}

class ListingsInitial extends ListingsState {}

class ListingsLoading extends ListingsState {}

class ListingsLoaded extends ListingsState {
  final List<ListingModel> listings;
  final bool hasReachedMax;
  final dynamic lastCursor;
  final double? userLat;
  final double? userLng;

  ListingsLoaded({
    required this.listings,
    this.hasReachedMax = false,
    this.lastCursor,
    this.userLat,
    this.userLng,
  });

  ListingsLoaded copyWith({
    List<ListingModel>? listings,
    bool? hasReachedMax,
    dynamic lastCursor,
    double? userLat,
    double? userLng,
  }) {
    return ListingsLoaded(
      listings: listings ?? this.listings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastCursor: lastCursor ?? this.lastCursor,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
    );
  }
}

class ListingsError extends ListingsState {
  final String error;
  ListingsError(this.error);
}
