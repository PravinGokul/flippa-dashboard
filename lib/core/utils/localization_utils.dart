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

