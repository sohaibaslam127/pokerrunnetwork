import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';
import 'package:pokerrunnetwork/config/global.dart';

class AdService {
  static final AdService I = AdService._();
  AdService._();

  Future<void> init() async {
    if (!enableAds) return;

    try {
      AdHelper.setupAdLogging();
      AdIdRegistry.initialize(
        ios: {AdType.native: adUnitId},
        android: {AdType.native: adUnitId},
      );
      logger.i("AdMob Service Initialized");
    } catch (e) {
      logger.e("Error initializing AdMob: $e");
    }
  }
}
