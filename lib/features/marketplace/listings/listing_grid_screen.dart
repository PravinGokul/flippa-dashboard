import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/listing_model.dart';
import '../listings/listings_bloc.dart';
import '../listings/listings_event.dart';
import '../listings/listings_state.dart';
import '../listings/listing_card.dart';
import 'package:flippa/ui/widgets/shimmer_loader.dart';

class ListingGridScreen extends StatefulWidget {
  const ListingGridScreen({super.key});

  @override
  State<ListingGridScreen> createState() => _ListingGridScreenState();
}

class _ListingGridScreenState extends State<ListingGridScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ListingsBloc>().add(FetchListings());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ListingsBloc>().add(FetchListings());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            // Calculate crossAxisCount dynamically: roughly 1 column per 250px on desktop
            final crossAxisCount = isDesktop 
                ? (constraints.maxWidth ~/ 250).clamp(2, 10) 
                : (constraints.maxWidth > 600 ? 3 : 2);
            
            return Column(
              children: [
                // Mockup 1: Top Search & Categories Area
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Search books, authors, genres...",
                                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      onSubmitted: (val) {
                                        context.read<ListingsBloc>().add(SearchListings(val));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.tune_rounded, color: Color(0xFF1E293B), size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip("All", true),
                            _buildCategoryChip("Fiction", false),
                            _buildCategoryChip("Sci-Fi", false),
                            _buildCategoryChip("Mystery", false),
                            _buildCategoryChip("Biography", false),
                            _buildCategoryChip("Art", false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Results Grid
                Expanded(
                  child: BlocBuilder<ListingsBloc, ListingsState>(
                    builder: (context, state) {
                      if (state is ListingsLoading) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: isDesktop ? 12 : 6,
                          itemBuilder: (_, __) => const ListingSkeleton(),
                        );
                      }

                      List<ListingModel> listings = [];
                      if (state is ListingsLoaded) {
                        listings = state.listings;
                      }

                      if (listings.isEmpty) {
                        return const Center(child: Text("No books found. Try a different search."));
                      }

                      return GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          return ListingCard(listing: listings[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
