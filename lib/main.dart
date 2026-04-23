import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flippa/services/analytics/ab_testing_service.dart';
import 'package:flippa/core/config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppConfig based on flavor
  final flavor = appFlavor ?? 'dev';
  
  AppEnvironment env = (flavor == 'prod') ? AppEnvironment.prod : 
                      (flavor == 'staging') ? AppEnvironment.staging : AppEnvironment.dev;

  AppConfig.init(environment: env);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Production Hardening: Firebase App Check Enforcement
    if (env == AppEnvironment.prod) {
      await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider('6Lfqv-4pAAAAAK_Z5e7-pG7S8S9Q9e9e9e9e9e9e'), // Placeholder site key
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    }

    await AbTestingService().init();

    // Local Emulator Connection (Dev/Staging only)
    if (env != AppEnvironment.prod) {
      const host = '127.0.0.1'; // Use 127.0.0.1 instead of localhost for better Windows/Web reliability
      
      try {
        debugPrint('--- Firebase Emulator Configuration ---');
        debugPrint('Project ID: ${Firebase.app().options.projectId}');
        debugPrint('Environment: $env');
        
        await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
        
        debugPrint('✅ Connected to local Firebase emulators at $host');
      } catch (e) {
        debugPrint('❌ Failed to connect to emulators: $e');
      }
    } else {
      debugPrint('ℹ️ Running in PROD mode - Emulators disabled');
    }
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }

  runApp(const FlippaApp());
}
