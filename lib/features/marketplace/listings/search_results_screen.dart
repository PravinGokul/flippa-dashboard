import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/features/marketplace/listings/listings_bloc.dart';
import 'package:flippa/features/marketplace/listings/listings_state.dart';
import 'package:flippa/features/marketplace/listings/listings_event.dart';
import 'package:flippa/ui/widgets/empty_state.dart';
import 'package:flippa/ui/widgets/shimmer_loader.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _selectedSort = "Reference";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    // Trigger initial search
    context.read<ListingsBloc>().add(SearchListings(widget.query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2C)),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF1E1E2C)),
            onPressed: () {
              // Open filter sheet
            },
          ),
        ],
      ),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildCategoryFilter(),
              _buildSortSection(),
              Expanded(
                child: _buildResultsList(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onSubmitted: (val) {
          context.read<ListingsBloc>().add(SearchListings(val));
        },
        decoration: InputDecoration(
          hintText: "Search books...",
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ["All", "Books", "Authors", "Genre"];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = cat),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF1E1E2C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SORT BY",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSortChip("Reference"),
              const SizedBox(width: 8),
              _buildSortChip("Price ↑"),
              const SizedBox(width: 8),
              _buildSortChip("Rating"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label) {
    final isSelected = _selectedSort == label;
    return InkWell(
      onTap: () => setState(() => _selectedSort = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E1E2C) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? const Color(0xFF1E1E2C) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(ListingsState state) {
    if (state is ListingsLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ListingSkeleton(),
      );
    }

    if (state is ListingsLoaded) {
      if (state.listings.isEmpty) {
        return const EmptyState(
          icon: Icons.search_off_rounded,
          title: "No results found",
          message: "We couldn't find any books matching your search. Try different keywords.",
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: state.listings.length,
        itemBuilder: (context, index) {
          return ListingCard(listing: state.listings[index]);
        },
      );
    }

    return const SizedBox.shrink();
  }
}
