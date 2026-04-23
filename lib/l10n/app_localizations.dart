import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'appTitle': 'Flippa',
      'listBook': 'List Book',
      'recommendedForYou': 'Recommended for You',
      'trendingNearYou': 'Trending Near You',
      'buy': 'Buy',
      'rent': 'Rent',
      'bid': 'Bid',
      'getAiSuggestion': 'Get AI Price Suggestion',
      'suggestedPrice': 'Suggested Price',
      'reason': 'Reason',
      'adminDashboard': 'Admin Dashboard',
      'activeDisputes': 'Active Disputes',
      'resolve': 'Resolve',
      'dismiss': 'Dismiss',
      'status': 'Status',
      'resolution': 'Resolution',
    },
    'es': {
      'appTitle': 'Flippa',
      'listBook': 'Publicar libro',
      'recommendedForYou': 'Recomendado para ti',
      'trendingNearYou': 'Tendencias cerca de ti',
      'buy': 'Comprar',
      'rent': 'Alquilar',
      'bid': 'Ofertar',
      'getAiSuggestion': 'Obtener sugerencia de precio AI',
      'suggestedPrice': 'Precio sugerido',
      'reason': 'Razón',
      'adminDashboard': 'Panel de Administración',
      'activeDisputes': 'Disputas Activas',
      'resolve': 'Resolver',
      'dismiss': 'Descartar',
      'status': 'Estado',
      'resolution': 'Resolución',
    },
    'hi': {
      'appTitle': 'Flippa',
      'listBook': 'किताब सूचीबद्ध करें',
      'recommendedForYou': 'आपके लिए अनुशंसित',
      'trendingNearYou': 'आपके पास ट्रेंडिंग',
      'buy': 'खरीदें',
      'rent': 'किराए पर लें',
      'bid': 'बोली लगाएं',
      'getAiSuggestion': 'एआई मूल्य सुझाव प्राप्त करें',
      'suggestedPrice': 'सुझाया गया मूल्य',
      'reason': 'कारण',
      'adminDashboard': 'एडमिन डैशबोर्ड',
      'activeDisputes': 'सक्रिय विवाद',
      'resolve': 'समाधान करें',
      'dismiss': 'खारिज करें',
      'status': 'स्थिति',
      'resolution': 'समाधान',
    },
    'fr': {
      'appTitle': 'Flippa',
      'listBook': 'Lister un livre',
      'recommendedForYou': 'Recommandé pour vous',
      'trendingNearYou': 'Tendances près de chez vous',
      'buy': 'Acheter',
      'rent': 'Louer',
      'bid': 'Enchérir',
      'getAiSuggestion': 'Obtenir une suggestion de prix AI',
      'suggestedPrice': 'Prix suggéré',
      'reason': 'Raison',
      'adminDashboard': 'Tableau de Bord Admin',
      'activeDisputes': 'Litiges Actifs',
      'resolve': 'Résoudre',
      'dismiss': 'Rejeter',
      'status': 'Statut',
      'resolution': 'Résolution',
    },
    'de': {
        'appTitle': 'Flippa',
        'listBook': 'Buch auflisten',
        'recommendedForYou': 'Empfohlen für dich',
        'trendingNearYou': 'Trends in deiner Nähe',
        'buy': 'Kaufen',
        'rent': 'Mieten',
        'bid': 'Bieten',
        'getAiSuggestion': 'KI-Preisvorschlag erhalten',
        'suggestedPrice': 'Vorgeschlagener Preis',
        'reason': 'Grund',
        'adminDashboard': 'Admin-Dashboard',
        'activeDisputes': 'Aktive Streitfälle',
        'resolve': 'Lösen',
        'dismiss': 'Verwerfen',
        'status': 'Status',
        'resolution': 'Lösung',
      },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get listBook => _localizedValues[locale.languageCode]!['listBook']!;
  String get recommendedForYou => _localizedValues[locale.languageCode]!['recommendedForYou']!;
  String get trendingNearYou => _localizedValues[locale.languageCode]!['trendingNearYou']!;
  String get buy => _localizedValues[locale.languageCode]!['buy']!;
  String get rent => _localizedValues[locale.languageCode]!['rent']!;
  String get bid => _localizedValues[locale.languageCode]!['bid']!;
  String get getAiSuggestion => _localizedValues[locale.languageCode]!['getAiSuggestion']!;
  String get suggestedPrice => _localizedValues[locale.languageCode]!['suggestedPrice']!;
  String get reason => _localizedValues[locale.languageCode]!['reason']!;
  String get adminDashboard => _localizedValues[locale.languageCode]!['adminDashboard']!;
  String get activeDisputes => _localizedValues[locale.languageCode]!['activeDisputes']!;
  String get resolve => _localizedValues[locale.languageCode]!['resolve']!;
  String get dismiss => _localizedValues[locale.languageCode]!['dismiss']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get resolution => _localizedValues[locale.languageCode]!['resolution']!;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'hi', 'fr', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
