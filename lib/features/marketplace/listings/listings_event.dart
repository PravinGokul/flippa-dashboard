import '../../../data/models/listing_model.dart';

abstract class ListingsEvent {}

class FetchListings extends ListingsEvent {}

class ListingsUpdated extends ListingsEvent {
  final List<ListingModel> listings;
  ListingsUpdated(this.listings);
}

class ListingsErrorOccurred extends ListingsEvent {
  final String error;
  ListingsErrorOccurred(this.error);
}
class SearchListings extends ListingsEvent {
  final String query;
  SearchListings(this.query);
}

class LoadMoreListings extends ListingsEvent {}

class AddListing extends ListingsEvent {
  final ListingModel listing;
  AddListing(this.listing);
}

class RemoveListing extends ListingsEvent {
  final String id;
  RemoveListing(this.id);
}

class FetchProximityListings extends ListingsEvent {
  final double latitude;
  final double longitude;
  FetchProximityListings(this.latitude, this.longitude);
}
