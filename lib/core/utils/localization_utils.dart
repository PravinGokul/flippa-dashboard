import 'package:flutter/material.dart';

class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('es', 'ES'),
  ];

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'हिन्दी';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }
}

class CurrencyService {
  static const List<String> supportedCurrencies = ['USD', 'INR', 'EUR'];

  static String getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      default:
        return '\$';
    }
  }

  static double getExchangeRate(String from, String to) {
    // These are dummy fixed rates for demonstration
    // In a real app, these would come from an API
    Map<String, double> rates = {
      'USD_INR': 83.0,
      'USD_EUR': 0.92,
      'INR_USD': 1/83.0,
      'EUR_USD': 1/0.92,
      'INR_EUR': 0.011,
      'EUR_INR': 90.0,
    };

    if (from == to) return 1.0;
    return rates['${from}_$to'] ?? 1.0;
  }

  static String formatPrice(double amount, String currencyCode) {
    final symbol = getCurrencySymbol(currencyCode);
    if (currencyCode == 'INR') {
      return '$symbol${amount.toStringAsFixed(0)}';
    }
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
