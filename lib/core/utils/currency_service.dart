import 'package:intl/intl.dart';

class CurrencyService {
  static const List<String> supportedCurrencies = ['USD', 'INR', 'EUR'];

  static String format(double amount, String currencyCode, {double exchangeRate = 1.0}) {
    final convertedAmount = amount * exchangeRate;
    
    final format = NumberFormat.currency(
      symbol: _getSymbol(currencyCode),
      decimalDigits: amount == amount.toInt() ? 0 : 2,
    );
    
    return format.format(convertedAmount);
  }

  static String _getSymbol(String code) {
    switch (code) {
      case 'INR': return '₹';
      case 'EUR': return '€';
      case 'USD': return '$';
      default: return '$';
    }
  }
}
