import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// Kullanıcının sahip olduğu varlıkları temsil eden model
/// BuyingAsset + güncel fiyat = UserAsset (portföy görünümü için)
class UserAssetModel {
  final String id; // Varlık ID'si
  final String assetType; // Varlık türü (ALTIN, EURTRY vs.)
  final String displayName; // Görüntülenecek isim
  final double quantity; // Miktar
  final double averagePrice; // Ortalama alış fiyatı
  final double currentPrice; // Şu anki fiyat (WebSocket'den)
  final double currentValue; // Şu anki değer (quantity × currentPrice)
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

  /// BuyingAsset + güncel fiyat → UserAsset dönüşümü
  /// Bu method portföy hesaplama için kritik
  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel buyingAsset,
    CurrencyData currentData,
  ) {
    // Şu anki fiyat (WebSocket'den gelen alış fiyatı)
    final currentPrice = currentData.buying ?? 0.0;

    // Bilezik özel durumu kontrolü
    double currentValue;
    if (buyingAsset.isBracelet && buyingAsset.gramWeight != null) {
      // Bilezik: gramWeight × ayarPrice
      // Burada ayar fiyatını currentPrice olarak kullanıyoruz
      currentValue = buyingAsset.gramWeight! * currentPrice;
    } else {
      // Normal: quantity × currentPrice
      currentValue = buyingAsset.quantity * currentPrice;
    }

    // Toplam yatırılan miktar
    final totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;

    // Kar/zarar hesaplama
    final change = currentValue - totalInvested;

    // Değişim yüzdesi hesaplama
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
    return assetType.getCurrencyName(); // Mevcut extension kullanımı
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
