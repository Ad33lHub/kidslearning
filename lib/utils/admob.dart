import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';
import 'app_constrant.dart';

class AdmobHelper {
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  static BannerAd getBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId ?? android_Google_banner,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );
  }

  void createInterad() {
    final unitId = AdHelper.interstitialAdUnitId;
    if (unitId == null) return;
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterad();
          }
        },
      ),
    );
  }

  void showInterad() {
    final ad = _interstitialAd;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterad();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterad();
      },
    );
    ad.show();
    _interstitialAd = null;
  }
}
