import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/signup_screen.dart';
import '../../features/marketplace/listings/listing_grid_screen.dart';
import '../../features/marketplace/listings/listing_detail_screen.dart';
import '../../features/marketplace/listings/search_results_screen.dart';
import '../../features/marketplace/orders/checkout_screen.dart';
import '../../features/marketplace/orders/order_history_screen.dart';
import '../../features/marketplace/orders/escrow_contract_screen.dart';
import '../../features/marketplace/orders/dispute_filing_screen.dart';
import '../../features/marketplace/orders/order_tracking_screen.dart';
import '../../features/marketplace/orders/return_flow_screen.dart';
import '../../features/marketplace/listings/auction_listing_screen.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../../features/dashboard/ui/my_flippa_screen.dart';
import '../../features/dashboard/ui/settings_screen.dart';
import '../../features/dashboard/ui/settings/edit_profile_screen.dart';
import '../../features/dashboard/ui/settings/security_screen.dart';
import '../../features/dashboard/ui/settings/payment_methods_screen.dart';
import '../../features/dashboard/ui/settings/notifications_settings_screen.dart';
import '../../features/dashboard/ui/settings/help_center_screen.dart';
import '../../features/dashboard/ui/settings/privacy_policy_screen.dart';
import '../../features/dashboard/ui/kyc_verification_screen.dart';
import '../../features/admin/ui/user_management_screen.dart';
import '../../features/admin/ui/admin_dispute_screen.dart';
import '../../features/home/ui/main_shell.dart';
import '../../features/dashboard/ui/tabs/summary_tab.dart';
import '../../ui/showcase_screen.dart';
import '../../data/models/listing_model.dart';

class AppRouter {
  static Page customTransitionPage<T>({
    required LocalKey key,
    required Widget child,
    String? name,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
    );
  }

  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const ListingGridScreen(),
            ),
          ),
          GoRoute(
            path: '/market',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const ListingGridScreen(),
            ),
          ),
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const Scaffold(body: SummaryTab()),
            ),
          ),
          GoRoute(
            path: '/my-flippa',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const MyFlippaScreen(),
            ),
          ),
          GoRoute(
            path: '/admin',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const AdminDisputeScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: '/listing/:id',
        pageBuilder: (context, state) {
          final listing = state.extra as ListingModel;
          return customTransitionPage(
            key: state.pageKey,
            child: ListingDetailScreen(listing: listing),
          );
        },
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return customTransitionPage(
            key: state.pageKey,
            child: SearchResultsScreen(query: query),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) {
          final listing = state.extra as ListingModel;
          return customTransitionPage(
            key: state.pageKey,
            child: CheckoutScreen(listing: listing),
          );
        },
      ),
      GoRoute(
        path: '/orders',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const OrderHistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/escrow-contract',
        pageBuilder: (context, state) {
          final listing = state.extra as ListingModel;
          return customTransitionPage(
            key: state.pageKey,
            child: EscrowContractScreen(listing: listing),
          );
        },
      ),
      GoRoute(
        path: '/dispute/:orderId',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return customTransitionPage(
            key: state.pageKey,
            child: DisputeFilingScreen(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'profile',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const EditProfileScreen(),
            ),
          ),
          GoRoute(
            path: 'security',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const SecurityScreen(),
            ),
          ),
          GoRoute(
            path: 'payment',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const PaymentMethodsScreen(),
            ),
          ),
          GoRoute(
            path: 'notifications',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const NotificationsSettingsScreen(),
            ),
          ),
          GoRoute(
            path: 'help',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const HelpCenterScreen(),
            ),
          ),
          GoRoute(
            path: 'privacy',
            pageBuilder: (context, state) => customTransitionPage(
              key: state.pageKey,
              child: const PrivacyPolicyScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/kyc',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const KYCVerificationScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/users',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const UserManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/auction',
        pageBuilder: (context, state) {
          final listing = state.extra as ListingModel;
          return customTransitionPage(
            key: state.pageKey,
            child: AuctionListingScreen(listing: listing),
          );
        },
      ),
      GoRoute(
        path: '/showcase',
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: const UIShowcaseScreen(),
        ),
      ),
      GoRoute(
        path: '/track/:orderId',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return customTransitionPage(
            key: state.pageKey,
            child: OrderTrackingScreen(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: '/return/:orderId',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return customTransitionPage(
            key: state.pageKey,
            child: ReturnFlowScreen(orderId: orderId),
          );
        },
      ),
    ],
  );
}


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title)),
    );
  }
}
