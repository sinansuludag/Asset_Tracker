import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// Kullanıcının sahip olduğu varlıkları temsil eden model
class UserAssetModel {
  final String id; // Varlık ID'si
  final String assetType; // Varlık türü
  final String displayName; // Görüntülenecek isim
  final double quantity; // Miktar
  final double averagePrice; // Ortalama alış fiyatı
  final double currentPrice; // Şu anki fiyat
  final double currentValue; // Şu anki değer
  final double change; // Değişim (₺)
  final double changePercentage; // Değişim (%)
  final String icon; // İkon
  final DateTime lastUpdated; // Son güncellenme

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

  /// BuyingAssetModel'den UserAssetModel oluşturma
  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel buyingAsset,
    CurrencyData currentData,
  ) {
    /// Şu anki fiyatı
    final currentPrice = currentData.buying ?? 0.0;

    /// Şu anki değeri
    final currentValue = buyingAsset.quantity * currentPrice;

    /// Toplam yatırılan miktar
    final totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;

    /// Kar/zarar hesaplama
    final change = currentValue - totalInvested;

    /// Değişim yüzdesi hesaplama
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

  static String _getDisplayName(String assetType) {
    // Mevcut extension'ınızı kullanın
    return assetType.getCurrencyName();
  }

  static String _getAssetIcon(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'altin':
      case 'gold':
        return 'AU';
      case 'usdtry':
      case 'usd':
        return '\$';
      case 'eurtry':
      case 'eur':
        return '€';
      case 'ayar14':
        return '14K';
      case 'ayar22':
        return '22K';
      case 'gumustry':
      case 'silver':
        return 'AG';
      default:
        return '₺';
    }
  }
}
