import '../../../data/models/listing_model.dart';

abstract class ListingsState {}

class ListingsInitial extends ListingsState {}

class ListingsLoading extends ListingsState {}

class ListingsLoaded extends ListingsState {
  final List<ListingModel> listings;
  final bool hasReachedMax;
  final dynamic lastCursor;

  ListingsLoaded({
    required this.listings,
    this.hasReachedMax = false,
    this.lastCursor,
  });

  ListingsLoaded copyWith({
    List<ListingModel>? listings,
    bool? hasReachedMax,
    dynamic lastCursor,
  }) {
    return ListingsLoaded(
      listings: listings ?? this.listings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastCursor: lastCursor ?? this.lastCursor,
    );
  }
}

class ListingsError extends ListingsState {
  final String error;
  ListingsError(this.error);
}
