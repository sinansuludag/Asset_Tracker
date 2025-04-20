import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';

extension CurrencyNameToCodeExtension on String {
  String? getCurrencyCode() {
    final map = {
      TrStrings.altin: 'ALTIN',
      TrStrings.ata5Eski: 'ATA5_ESKI',
      TrStrings.ata5Yeni: 'ATA5_YENI',
      TrStrings.ataEski: 'ATA_ESKI',
      TrStrings.ataYeni: 'ATA_YENI',
      TrStrings.audTry: 'AUDTRY',
      TrStrings.audUsd: 'AUDUSD',
      TrStrings.ayar14: 'AYAR14',
      TrStrings.ayar22: 'AYAR22',
      TrStrings.cadTry: 'CADTRY',
      TrStrings.ceyrekEski: 'CEYREK_ESKI',
      TrStrings.ceyrekYeni: 'CEYREK_YENI',
      TrStrings.chfTry: 'CHFTRY',
      TrStrings.dkkTry: 'DKKTRY',
      TrStrings.eurKg: 'EURKG',
      TrStrings.eurTry: 'EURTRY',
      TrStrings.eurUsd: 'EURUSD',
      TrStrings.gbpTry: 'GBPTRY',
      TrStrings.gbpUsd: 'GBPUSD',
      TrStrings.gremeseEski: 'GREMESE_ESKI',
      TrStrings.gremeseYeni: 'GREMESE_YENI',
      TrStrings.gumusTry: 'GUMUSTRY',
      TrStrings.gumusUsd: 'GUMUSUSD',
      TrStrings.jpyTry: 'JPYTRY',
      TrStrings.kulceAltin: 'KULCEALTIN',
      TrStrings.nokTry: 'NOKTRY',
      TrStrings.ons: 'ONS',
      TrStrings.paladyum: 'PALADYUM',
      TrStrings.xptUsd: 'XPTUSD',
      TrStrings.sarTry: 'SARTRY',
      TrStrings.sekTry: 'SEKTRY',
      TrStrings.tekEski: 'TEK_ESKI',
      TrStrings.tekYeni: 'TEK_YENI',
      TrStrings.usdCad: 'USDCAD',
      TrStrings.usdChf: 'USDCHF',
      TrStrings.usdJpy: 'USDJPY',
      TrStrings.usdKg: 'USDKG',
      TrStrings.usdPure: 'USDPURE',
      TrStrings.usdSar: 'USDSAR',
      TrStrings.usdTry: 'USDTRY',
      TrStrings.xagUsd: 'XAGUSD',
      TrStrings.xauXag: 'XAUXAG',
      TrStrings.xpdUsd: 'XPDUSD',
      TrStrings.yarimEski: 'YARIM_ESKI',
      TrStrings.yarimYeni: 'YARIM_YENI',
    };

    return map.entries
        .firstWhere((entry) => entry.key.toLowerCase() == this.toLowerCase(),
            orElse: () => const MapEntry('', ''))
        .value;
  }
}
