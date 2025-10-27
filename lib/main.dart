import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodu/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:foodu/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {
  /// -- Uncomment this line if you want to use any of features below
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  /// -- INIT Local Storage
  await GetStorage.init();

  // Load .env file if it exists, otherwise continue without it
  try {
    await dotenv.load(fileName: ".env");
    print('✅ Environment variables loaded successfully');
  } catch (e) {
    // .env file not found or couldn't be loaded - continue without it
    print('⚠️  Warning: .env file not found or couldn\'t be loaded');
    print(
        '📝 To enable full functionality, create a .env file with your Google API key');
    print('📖 See ENV_SETUP.md for detailed instructions');
    print('🔧 Error details: $e');
  }

  /// -- Overcome from transparent spaces at the bottom in iOS full Mode, [Use only if needed]
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  /// -- Await Splash until other items Loaded
  /// Note: Make sure to call FlutterNativeSplash.remove();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// -- Initialize Firebase & Authentication Repository if any
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  /// -- Initialize Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  /// -- Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  FlutterNativeSplash.remove();

  /// -- Main App Starts here...
  runApp(const App());
}
