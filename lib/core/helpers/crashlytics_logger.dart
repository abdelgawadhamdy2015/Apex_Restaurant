import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsLogger {
  static Future<void> logError({
    required String screen,
    String? message,
    Map<String, dynamic>? keys,
    required dynamic error,
    required StackTrace stackTrace,
    bool fatal = false,
  }) async {
    final crashlytics = FirebaseCrashlytics.instance;

    // Required: screen name
    await crashlytics.setCustomKey("screen", screen);

    // Optional: message
    if (message != null) {
      await crashlytics.log(message);
    }

    // Optional: additional keys
    if (keys != null) {
      for (final entry in keys.entries) {
        await crashlytics.setCustomKey(entry.key, entry.value.toString());
      }
    }

    // Record the actual error
    await crashlytics.recordError(error, stackTrace, fatal: fatal);
    
  }
}
