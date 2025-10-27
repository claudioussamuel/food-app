//
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//
// class TCrashlyticsHelper {
//   static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
//
//   // Log a custom message or error
//   static void log(String message) {
//     _crashlytics.log(message);
//   }
//
//   // Log a caught exception
//   static void recordException(Exception exception, [StackTrace? stackTrace]) {
//     _crashlytics.recordError(exception, stackTrace);
//   }
//
//   // Log a non-fatal error
//   static void recordError(dynamic error, [StackTrace? stackTrace]) {
//     _crashlytics.recordError(error, stackTrace);
//   }
//
//   // Log a success event or message
//   static void logSuccess(String message) {
//     _crashlytics.log('SUCCESS: $message');
//   }
//
//   // Log a user ID for better context
//   static void setUserId(String userId) {
//     _crashlytics.setUserIdentifier(userId);
//   }
// }
