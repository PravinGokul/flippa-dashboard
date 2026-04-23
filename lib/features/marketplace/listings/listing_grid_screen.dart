import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/config/app_constants.dart';
import '../../../ui/widgets/glass/glass_card.dart';
import '../../../ui/widgets/glass/glass_app_bar.dart';
import '../../../ui/widgets/glass/glass_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/ui/seller_verification_screen.dart';
import '../../auth/ui/login_screen.dart';
import '../../../data/models/listing_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flippa/state/global_state_bloc.dart';
import 'package:flippa/core/utils/localization_utils.dart';
import 'package:flippa/services/ai/recommendation_service.dart';
import 'package:flippa/features/marketplace/listings/listing_card.dart';
import 'package:flippa/features/marketplace/listings/add_listing_dialog.dart';
import 'package:flippa/features/home/ui/home_feed.dart';
import 'package:flippa/services/analytics/ab_testing_service.dart';
import 'package:flippa/features/dashboard/ui/seller_insights.dart';
import 'package:flippa/features/marketplace/listings/listings_bloc.dart';
import 'package:flippa/features/marketplace/listings/listings_event.dart';
import 'package:flippa/features/marketplace/listings/listings_state.dart';
import 'package:flippa/core/utils/seed_service.dart';
import 'package:flippa/core/auth/auth_service.dart';

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
    // Trigger initial fetch using the repository gate
    context.read<ListingsBloc>().add(FetchListings());
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ListingsBloc>().add(LoadMoreListings());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger when user is 200px from bottom for smoother transition
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: const Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              const Text(
                'Flippa',
                style: TextStyle(
                  color: Color(0xFF1E1E2C),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 40),
              _buildSearchBar(),
              const Spacer(),
              _buildListBookButton(context),
              const SizedBox(width: 24),
              _buildGenreDropdown(),
              const SizedBox(width: 24),
              _buildHeaderAction(Icons.favorite_border, () {}),
              const SizedBox(width: 16),
              // Prototype Seeding Trigger
              _buildHeaderAction(Icons.auto_awesome, () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Starting Live Data Seed...')),
                );
                await SeedService().seedListings();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Seed Complete! Restart app to see live Firestore data.')),
                );
              }),
              const SizedBox(width: 16),
              _buildLanguagePicker(context),
              const SizedBox(width: 16),
              _buildCurrencyPicker(context),
              const SizedBox(width: 16),
              _buildAccountAction(context),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8EAF6), // Soft lavender
              Color(0xFFEDE7F6), // Soft purple
              Color(0xFFF1F5F9), // Very light blue
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeroSection(),
              _buildStatsSection(),
              const SizedBox(height: 60),
              BlocBuilder<ListingsBloc, ListingsState>(
                builder: (context, state) {
                  if (state is ListingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<ListingModel> allListings = [];
                  if (state is ListingsLoaded) {
                    allListings = state.listings;
                  }

                  final trending = allListings.where((l) => l.section == 'trending').toList();
                  final newReleases = allListings.where((l) => l.section == 'new_releases').toList();
                  final localAuthors = allListings.where((l) => l.section == 'local_authors').toList();

                  return Column(
                    children: [
                       _buildHorizontalSection('Trending Near You', trending),
                       const SizedBox(height: 48),
                       _buildHorizontalSection('New Releases', newReleases),
                       const SizedBox(height: 48),
                       _buildHorizontalSection('Local Authors', localAuthors),
                       const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSection(String title, List<ListingModel> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.w900, 
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const Icon(Icons.arrow_forward, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 380, // Increased height to prevent vertical overflow
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: 220, // Consistent with previous established width
                  child: ListingCard(listing: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 350,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          context.read<ListingsBloc>().add(SearchListings(value));
        },
        decoration: const InputDecoration(
          hintText: 'Search for books...',
          suffixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: const Color(0xFF1E1E2C), size: 24),
      ),
    );
  }

  Widget _buildListBookButton(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(context: context, builder: (_) => const AddListingDialog()),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              'List Book',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.blue.withOpacity(0.05),
            Colors.purple.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: const Icon(Icons.menu_book_rounded, size: 40, color: Color(0xFF1E1E2C)),
          ),
          const SizedBox(height: 32),
          const Text(
            'Flippa',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('Premium Literary Collection', style: TextStyle(fontSize: 18, color: Color(0xFF4B5563))),
              SizedBox(width: 8),
              Icon(Icons.workspace_premium, color: Colors.orange, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Discover rare first editions, beloved classics, and contemporary masterpieces. Join India\'s most exclusive community of book collectors and literary enthusiasts.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280), height: 1.6),
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildHeroButton('Start Collecting', const Color(0xFF111827), Colors.white),
              _buildHeroButton('Browse Collection', const Color(0xFFF3F4F6), const Color(0xFF111827)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroButton(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildStatsSection() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildStatCard('10,000+', 'PREMIUM BOOKS'),
        _buildStatCard('5,000+', 'HAPPY READERS'),
        _buildStatCard('100+', 'CITIES'),
      ],
    );
  }

  Widget _buildStatCard(String val, String label) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 20,
      onSelected: (String value) {
        // Implement filtering logic here
      },
      itemBuilder: (BuildContext context) {
        return AppConstants.genres.map((String genre) {
          return PopupMenuItem<String>(
            value: genre,
            child: Text(
              genre,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Genres',
              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569), fontSize: 13),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF475569)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagePicker(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Color(0xFF1E1E2C), size: 24),
      onSelected: (Locale locale) {
        context.read<GlobalBloc>().add(GlobalEvent.changeLanguage(locale));
      },
      itemBuilder: (context) => LocalizationService.supportedLocales.map((locale) {
        return PopupMenuItem(
          value: locale,
          child: Text(LocalizationService.getLanguageName(locale)),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencyPicker(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.payments_outlined, color: Color(0xFF1E1E2C), size: 24),
      onSelected: (String currency) {
        context.read<GlobalBloc>().add(GlobalEvent.changeCurrency(currency));
      },
      itemBuilder: (context) => CurrencyService.supportedCurrencies.map((currency) {
        return PopupMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
    );
  }

  Widget _buildAccountAction(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return _buildHeaderAction(Icons.person_outline, () => context.push('/login'));
        }

        return _buildProfileOverlay(context, user);
      },
    );
  }

  Widget _buildProfileOverlay(BuildContext context, User user) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 20,
      onSelected: (String value) async {
        if (value == 'logout') {
          await context.read<AuthService>().signOut();
        } else if (value == 'my-flippa') {
          context.push('/my-flippa');
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? user.email?.split('@').first ?? "User",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  user.email ?? "",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const Divider(),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'my-flippa',
            child: Row(
              children: [
                Icon(Icons.account_circle_outlined, size: 20, color: Color(0xFF475569)),
                SizedBox(width: 12),
                Text('My Flippa', style: TextStyle(color: Color(0xFF1E293B))),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout_rounded, size: 20, color: Colors.redAccent),
                SizedBox(width: 12),
                Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Color(0xFF1E1E2C), size: 24),
      ),
    );
  }
}
