import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  static Map<String, String> links = {
    'fb': 'https://www.facebook.com/HakunaMatataToken',
    'twitter': 'https://twitter.com/HKUNtoken',
    'ig': 'https://www.instagram.com/hkuntoken',
    'hkun': 'https://hakunamatatatoken.com/',
    'telegram': 'https://t.me/HKUNtoken',
    'youtube': 'https://www.youtube.com/channel/UC-UUoGWO_MCcPusXptzCmkA',
    'buyHkun':
        'https://pancakeswap.finance/swap?outputCurrency=0xbb2fa5b2d19209f4cf50cf745efc32641a7c9fb1',
    'claimBUSD': 'https://dashboard.hakunamatatatoken.com/',
    'poocoin':
        'https://poocoin.app/tokens/0xbb2fa5b2d19209f4cf50cf745efc32641a7c9fb1',
    'bogged':
        'https://charts.bogged.finance/0xBb2FA5B2D19209f4Cf50cF745Efc32641A7c9fb1',
    'lbank': 'https://www.lbank.info/exchange/hkun/usdt',
  };

  static Future<void> launchBogged() async {
    try {
      await launch(links['bogged']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchPooCoin() async {
    try {
      await launch(links['poocoin']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchLBank() async {
    try {
      await launch(links['lbank']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchFacebook() async {
    try {
      await launch(links['fb']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchTwitter() async {
    try {
      await launch(links['twitter']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchInstagram() async {
    try {
      await launch(links['ig']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchWebsite() async {
    try {
      await launch(links['hkun']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchTelegram() async {
    try {
      await launch(links['telegram']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchYoutube() async {
    try {
      await launch(links['youtube']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchPancakeSwap() async {
    try {
      await launch(links['buyHkun']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  static Future<void> launchClaimBUSD() async {
    try {
      await launch(links['claimBUSD']!);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }
}
