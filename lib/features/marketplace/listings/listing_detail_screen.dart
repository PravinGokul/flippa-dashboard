import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/currency_service.dart';
import '../../../data/models/listing_model.dart';
import '../../../ui/widgets/glass/glass_container.dart';
import '../../../ui/widgets/glass/glass_button.dart';
import '../../rentals/ui/availability_calendar.dart';

class ListingDetailScreen extends StatefulWidget {
  final ListingModel listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  const SizedBox(height: 32),
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildTabs(),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 400, // Height for tab content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(),
                        AvailabilityCalendar(
                          listingId: widget.listing.id,
                          pricePerDay: widget.listing.priceRentDaily ?? 49.0,
                        ),
                        _buildReviewsTab(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E2C)),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Color(0xFF1E1E2C)),
          onPressed: () {
            Share.share(
              'Check out this book on Flippa: ${widget.listing.title} by ${widget.listing.author}. View it here: https://flippa.app/listing/${widget.listing.id}',
              subject: 'Look what I found on Flippa!',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Color(0xFF1E1E2C)),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.listing.imageUrls?.first ?? 'https://via.placeholder.com/600x800',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        final rate = state.exchangeRate;
        final currency = state.currency;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.listing.genre ?? "Literary",
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.listing.rating?.toString() ?? "4.8",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.listing.title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
            ),
            const SizedBox(height: 8),
            Text(
              "by ${widget.listing.author}",
              style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  CurrencyService.format(widget.listing.priceSale ?? 0.0, currency, exchangeRate: rate),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C)),
                ),
                if (widget.listing.isAvailableForRent) ...[
                  const SizedBox(width: 16),
                  Text(
                    "Rent ${CurrencyService.format(widget.listing.priceRentDaily ?? 0.0, currency, exchangeRate: rate)}/d",
                    style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(Icons.library_books_outlined, "8 Bookings"),
        _buildStatItem(Icons.visibility_outlined, "142 Views"),
        _buildStatItem(Icons.check_circle_outline, "Available", color: Colors.green),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? const Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1E1E2C),
        unselectedLabelColor: const Color(0xFF94A3B8),
        indicatorColor: const Color(0xFF1E1E2C),
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Rent"),
          Tab(text: "Reviews"),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        widget.listing.description ?? "A classic guide to software craftsmanship, this book has been influential for generations of developers. It provides deep insights into the art and science of writing clean, maintainable code.",
        style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563), height: 1.6),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return const Center(child: Text("No reviews yet. Be the first to review!"));
  }

  Widget _buildBottomActions() {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        final rate = state.exchangeRate;
        final currency = state.currency;
        final price = widget.listing.priceSale ?? 0.0;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GlassButton(
                  label: "Buy - ${CurrencyService.format(price, currency, exchangeRate: rate)}",
                  onPressed: () {
                    context.push('/checkout', extra: widget.listing);
                  },
                  color: const Color(0xFF1E1E2C),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF1E1E2C)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Rent this Book",
                    style: TextStyle(color: Color(0xFF1E1E2C), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
