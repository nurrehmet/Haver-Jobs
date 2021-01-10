import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7163496651789613~7999697763";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7163496651789613~7999697763";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7163496651789613/7037969885";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7163496651789613/7037969885";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdTestID {
    return "ca-app-pub-3940256099942544/6300978111";
  }
  static String get interstitialAdTestID {
    return "ca-app-pub-3940256099942544/1033173712";
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7163496651789613/3514476083";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7163496651789613/3514476083";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7163496651789613/5728757645";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7163496651789613/5728757645";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}