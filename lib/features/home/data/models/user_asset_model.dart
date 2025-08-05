import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// Kullanıcının sahip olduğu varlıkları temsil eden model
/// BuyingAsset + güncel fiyat = UserAsset (portföy görünümü için)
class UserAssetModel {
  final String id;
  final String assetType;
  final String displayName;
  final double quantity;
  final double averagePrice;
  final double currentPrice;
  final double currentValue;
  final double change;
  final double changePercentage;
  final String icon;
  final DateTime lastUpdated;

  const UserAssetModel({
    required this.id,
    required this.assetType,
    required this.displayName,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.currentValue,
    required this.change,
    required this.changePercentage,
    required this.icon,
    required this.lastUpdated,
  });

  /// BuyingAsset + güncel fiyat → UserAsset dönüşümü
  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel buyingAsset,
    CurrencyData currentData,
  ) {
    double currentPrice;
    double currentValue;
    double totalInvested;

    if (buyingAsset.isBracelet && buyingAsset.gramWeight != null) {
      // ✅ BİLEZİK HESAPLAMASI (Saf altın değeri)

      // Ayar oranlarını direkt burada belirle
      double pureGoldRatio;
      switch (buyingAsset.assetType.toUpperCase()) {
        case 'AYAR14':
          pureGoldRatio = 0.585; // %58.5 saf altın
          break;
        case 'AYAR22':
          pureGoldRatio = 0.917; // %91.7 saf altın
          break;
        default:
          pureGoldRatio = 1.0; // %100 saf altın (24K)
      }

      // Saf altın ağırlığı hesapla
      double pureGoldWeight = buyingAsset.gramWeight! * pureGoldRatio;

      // Şu anki altın fiyatı (24K)
      currentPrice = currentData.buying ?? 0.0;

      // Şu anki değer = saf altın ağırlığı × güncel altın fiyatı
      currentValue = pureGoldWeight * currentPrice;

      // Yatırılan miktar = quantity × alış fiyatı
      totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;
    } else {
      // ✅ NORMAL VARLIK HESAPLAMASI

      // Şu anki fiyat (WebSocket'den)
      currentPrice = currentData.buying ?? 0.0;

      // Şu anki değer = quantity × güncel fiyat
      currentValue = buyingAsset.quantity * currentPrice;

      // Yatırılan miktar = quantity × alış fiyatı
      totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;
    }

    // Kar/zarar hesaplama
    final change = currentValue - totalInvested;

    // Değişim yüzdesi
    final changePercentage =
        totalInvested > 0 ? (change / totalInvested) * 100 : 0.0;

    return UserAssetModel(
      id: buyingAsset.id,
      assetType: buyingAsset.assetType,
      displayName: _getDisplayName(buyingAsset.assetType),
      quantity: buyingAsset.quantity,
      averagePrice: buyingAsset.buyingPrice,
      currentPrice: currentPrice,
      currentValue: currentValue,
      change: change,
      changePercentage: changePercentage,
      icon: _getAssetIcon(buyingAsset.assetType),
      lastUpdated: DateTime.now(),
    );
  }

  /// Varlık kodunu Türkçe isme çevirme
  static String _getDisplayName(String assetType) {
    return assetType.getCurrencyName();
  }

  /// Varlık türüne göre ikon belirleme
  static String _getAssetIcon(String assetType) {
    switch (assetType.toUpperCase()) {
      case 'ALTIN':
      case 'KULCEALTIN':
        return 'AU';
      case 'USDTRY':
        return '\$';
      case 'EURTRY':
        return '€';
      case 'GBPTRY':
        return '£';
      case 'AYAR14':
        return '14K';
      case 'AYAR22':
        return '22K';
      case 'GUMUSTRY':
        return 'AG';
      case 'PLATIN':
        return 'PT';
      default:
        return '₺';
    }
  }
}
