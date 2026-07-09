import 'package:flutter/foundation.dart';

// Override with --dart-define=SERVER_BASE_URL=... for physical devices.
String get serverBaseUrl {
  const override = String.fromEnvironment('SERVER_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  if (kIsWeb) {
    return 'http://localhost:3000';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'http://10.0.2.2:3000';
    default:
      return 'http://localhost:3000';
  }
}

// Put your Stripe publishable key here (pk_test_...)
const String stripePublishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
