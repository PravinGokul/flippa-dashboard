import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Initializes and presents the Stripe Payment Sheet
  Future<void> startPayment({
    required int amount,
    required String currency,
    required String listingId,
    required String startDate,
    required String endDate,
    required BuildContext context,
  }) async {
    try {
      // 1. Call Cloud Function to create a PaymentIntent
      final result = await _functions.httpsCallable('createPaymentIntent').call({
        'amount': amount,
        'currency': currency,
        'listingId': listingId,
        'startDate': startDate,
        'endDate': endDate,
      });

      final clientSecret = result.data['clientSecret'];
      final paymentIntentId = result.data['paymentIntentId'];

      // 2. Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Flippa',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF1E1E2C),
            ),
          ),
        ),
      );

      // 3. Present the Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Fulfillment: Call bookRental after success
      // In a production app, the webhook handleStripeWebhook serves as the source of truth,
      // but we call bookRental here for immediate UI feedback.
      await _functions.httpsCallable('bookRental').call({
        'listingId': listingId,
        'startDate': startDate,
        'endDate': endDate,
        'paymentIntentId': paymentIntentId,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking Confirmed!')),
        );
      }
    } catch (e) {
      if (e is StripeException) {
        debugPrint("Stripe Error: ${e.error.localizedMessage}");
      } else {
        debugPrint("Booking Error: $e");
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction failed: $e')),
        );
      }
    }
  }
}
