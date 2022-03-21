// Package imports:
import 'dart:async';
import 'dart:io';

import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:pocketark/constants/application_constants.dart';
import 'package:pocketark/services/service_configuration.dart';

import '../events/adverts_updated_event.dart';

enum ApplicationEnvironment {
  development,
  production,
}

class ApplicationService extends InqvineServiceBase with PocketArkServiceMixin {
  // Set this prior to the service being created to set the environment
  // Example: `inqvine.registerInLocator(ApplicationEnvironment.development);` in [main_dev.dart]
  ApplicationEnvironment get environment {
    if (inqvine.isRegisteredInLocator<ApplicationEnvironment>()) {
      return inqvine.getFromLocator();
    }

    return ApplicationEnvironment.development;
  }

  bool _advertsInitialized = false;
  bool get advertsInitialized => _advertsInitialized;

  BannerAdListener? _mobileSplashBannerAdListener;
  BannerAdListener? get mobileSplashBannerAdListener => _mobileSplashBannerAdListener;

  BannerAd? _mobileSplashBannerAd;
  BannerAd? get mobileSplashBannerAd => _mobileSplashBannerAd;

  String get mobileSplashAdvertIdentifier {
    if (environment == ApplicationEnvironment.development) {
      return kAdvertTestSplashAdUnitId;
    }

    return Platform.isAndroid ? kAdvertAndroidSplashAdUnitId : kAdvertIOSSplashAdUnitId;
  }

  @override
  Future<void> initializeService() {
    unawaited(attemptInitializeAds());
    return super.initializeService();
  }

  Future<void> attemptInitializeAds() async {
    'Attempting to initialize adverts'.logDebug();
    if (advertsInitialized) {
      return;
    }

    await mobileAds.initialize();

    _mobileSplashBannerAdListener = BannerAdListener(onAdClicked: onAdvertClicked);
    _mobileSplashBannerAd = BannerAd(size: AdSize.banner, adUnitId: mobileSplashAdvertIdentifier, listener: _mobileSplashBannerAdListener!, request: const AdRequest());
    await _mobileSplashBannerAd?.load();

    _advertsInitialized = true;
    inqvine.publishEvent(AdvertsUpdatedEvent());
    'Initialized adverts successfully'.logDebug();
  }

  void onAdvertClicked(Ad ad) {
    'Advert clicked: ${ad.adUnitId}'.logDebug();
  }
}
