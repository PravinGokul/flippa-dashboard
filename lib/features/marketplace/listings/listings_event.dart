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
