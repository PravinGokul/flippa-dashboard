
enum AppEnvironment {
  dev,
  staging,
  prod,
}

class AppConfig {
  final AppEnvironment environment;
  final String appTitle;
  // Add other environment-specific configs here

  AppConfig({
    required this.environment,
    required this.appTitle,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized');
    }
    return _instance!;
  }

  static void init({
    required AppEnvironment environment,
  }) {
    String title;
    switch (environment) {
      case AppEnvironment.dev:
        title = 'Flippa Dev';
        break;
      case AppEnvironment.staging:
        title = 'Flippa Staging';
        break;
      case AppEnvironment.prod:
        title = 'Flippa';
        break;
    }

    _instance = AppConfig(
      environment: environment,
      appTitle: title,
    );
  }
}
