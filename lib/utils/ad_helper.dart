import 'dart:io';
import 'app_constrant.dart';



class AdHelper {
  static bool get isSupported => Platform.isAndroid || Platform.isIOS;

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) return android_Google_banner;
    if (Platform.isIOS) return ios_Google_banner;
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) return android_Google_interstitial;
    if (Platform.isIOS) return ios_Google_interstitial;
    return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/8673189370';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/7552160883';
    return null;
  }
}
