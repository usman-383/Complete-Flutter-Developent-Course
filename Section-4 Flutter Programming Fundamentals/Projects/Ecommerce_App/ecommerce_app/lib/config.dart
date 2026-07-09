import 'package:flutter/foundation.dart';

// Override with --dart-define=SERVER_BASE_URL=... if you need a different host.
String get serverBaseUrl {
  const override = String.fromEnvironment(
    'SERVER_BASE_URL',
    defaultValue: 'http://192.168.100.16:3000',
  );
  if (override.isNotEmpty) {
    return override;
  }

  if (kIsWeb) {
    return 'http://localhost:3000';
  }

  return defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000'
      : 'http://192.168.100.16:3000';
}

// Put your Stripe publishable key here (pk_test_...)
const String stripePublishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
