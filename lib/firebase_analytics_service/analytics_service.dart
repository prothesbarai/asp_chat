import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // >>> For All Page automatic track purpose ==================================
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);
  // <<< For All Page automatic track purpose ==================================


  // >>> For All Page manual track purpose =====================================
  static Future<void> logPageView(String pageName) async {
    debugPrint("Logging screen: $pageName");
    await _analytics.logScreenView(screenName: pageName, screenClass: pageName,);
  }
  // <<< For All Page manual track purpose =====================================


  // >>> For Any Specific Item Track Purpose ===================================
  static Future<void> logProductView({required String productId, required String productName,}) async {
    await _analytics.logEvent(
      name: "view_product",
      parameters: {
        "product_id": productId,
        "product_name": productName,
        'timestamp': DateTime.now().toString(),
      },
    );
  }
  // <<< For Any Specific Item Track Purpose ===================================
}
