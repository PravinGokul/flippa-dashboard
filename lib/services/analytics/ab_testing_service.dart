import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AbTestingService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.setDefaults({
      "home_feed_variant": "control",
    });
    await _remoteConfig.fetchAndActivate();
  }

  String getHomeFeedVariant() {
    String variant = _remoteConfig.getString("home_feed_variant");
    _analytics.logEvent(
      name: "experiment_exposed",
      parameters: {
        "experiment": "home_feed_v1",
        "variant": variant,
      },
    );
    return variant;
  }
}
