import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/listings_repository.dart';
import '../../../data/models/listing_model.dart';
import 'listings_event.dart';
import 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final ListingsRepository _repository;
  StreamSubscription? _subscription;

  ListingsBloc(this._repository) : super(ListingsInitial()) {
    on<FetchListings>((event, emit) async {
      emit(ListingsLoading());
      try {
        final result = await _repository.getListings(limit: 10);
        emit(ListingsLoaded(
          listings: result.listings,
          hasReachedMax: !result.hasMore,
          lastCursor: result.lastCursor,
        ));
      } catch (e) {
        emit(ListingsError(e.toString()));
      }
    });

    on<FetchProximityListings>((event, emit) async {
      emit(ListingsLoading());
      try {
        final result = await _repository.getListingsNearLocation(
          latitude: event.latitude,
          longitude: event.longitude,
          limit: 10,
        );
        emit(ListingsLoaded(
          listings: result.listings,
          hasReachedMax: !result.hasMore,
          lastCursor: result.lastCursor,
          userLat: event.latitude,
          userLng: event.longitude,
        ));
      } catch (e) {
        emit(ListingsError(e.toString()));
      }
    });

    on<LoadMoreListings>((event, emit) async {
      final currentState = state;
      if (currentState is ListingsLoaded && !currentState.hasReachedMax) {
        try {
          final PaginatedListings result;
          if (currentState.userLat != null && currentState.userLng != null) {
            result = await _repository.getListingsNearLocation(
              latitude: currentState.userLat!,
              longitude: currentState.userLng!,
              limit: 10,
              lastCursor: currentState.lastCursor,
            );
          } else {
            result = await _repository.getListings(
              limit: 10,
              lastCursor: currentState.lastCursor,
            );
          }
          
          emit(result.listings.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ListingsLoaded(
                  listings: currentState.listings + result.listings,
                  hasReachedMax: !result.hasMore,
                  lastCursor: result.lastCursor,
                  userLat: currentState.userLat,
                  userLng: currentState.userLng,
                ));
        } catch (e) {
          emit(ListingsError(e.toString()));
        }
      }
    });

    on<ListingsUpdated>((event, emit) {
      emit(ListingsLoaded(listings: event.listings));
    });

    on<ListingsErrorOccurred>((event, emit) {
      emit(ListingsError(event.error));
    });

    on<SearchListings>((event, emit) async {
      final query = event.query.toLowerCase();
      if (query.isEmpty) {
        add(FetchListings());
        return;
      }
      
      emit(ListingsLoading());
      try {
        // Search currently fetches a larger set (or a specific search collection in prod)
        // For simplicity in demo, we fetch the first 50 and filter
        final result = await _repository.getListings(limit: 50);
        final filteredListings = result.listings.where((l) => 
          l.title.toLowerCase().contains(query) || 
          l.author.toLowerCase().contains(query) ||
          l.category.toLowerCase().contains(query)).toList();
        
        emit(ListingsLoaded(
          listings: filteredListings,
          hasReachedMax: true, // Search results usually don't paginate the same way here
        ));
      } catch (e) {
        emit(ListingsError(e.toString()));
      }
    });

    on<AddListing>((event, emit) {
      final currentState = state;
      if (currentState is ListingsLoaded) {
        emit(ListingsLoaded(
          listings: [event.listing, ...currentState.listings],
          hasReachedMax: currentState.hasReachedMax,
          lastCursor: currentState.lastCursor,
        ));
      } else {
        emit(ListingsLoaded(listings: [event.listing], hasReachedMax: true));
      }
    });

    on<RemoveListing>((event, emit) {
      final currentState = state;
      if (currentState is ListingsLoaded) {
        final newListings = currentState.listings.where((l) => l.id != event.id).toList();
        emit(ListingsLoaded(
          listings: newListings,
          hasReachedMax: currentState.hasReachedMax,
          lastCursor: currentState.lastCursor,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
