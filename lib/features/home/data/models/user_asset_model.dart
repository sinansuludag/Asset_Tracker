import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

import 'buying_asset_model.dart';

/// Hesaplanmış portföy varlığı - UI'da gösterilir
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
  final bool isBracelet;
  final String? ayarType;
  final double? gramWeight;

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
    this.isBracelet = false,
    this.ayarType,
    this.gramWeight,
  });

  /// ✅ TEK FACTORY METHOD - WebSocket ile hesaplama
  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel buyingAsset,
    CurrencyResponse currencyResponse,
  ) {
    double currentPrice = 0.0;
    double currentValue = 0.0;
    final totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;

    if (buyingAsset.isBracelet &&
        buyingAsset.gramWeight != null &&
        buyingAsset.ayarType != null) {
      // BİLEZİK HESAPLAMASI
      final ayarData =
          currencyResponse.currencies['AYAR${buyingAsset.ayarType}'];

      if (ayarData?.buying != null) {
        // WebSocket'den ayar fiyatı var
        currentPrice = ayarData!.buying!;
        currentValue = buyingAsset.gramWeight! * currentPrice;
      } else {
        // Fallback: Saf altın hesaplama
        final goldData = currencyResponse.currencies['ALTIN'];
        final goldPrice = goldData?.buying ?? 0.0;

        double pureGoldRatio = buyingAsset.ayarType == '14' ? 0.585 : 0.917;
        currentPrice = goldPrice * pureGoldRatio;
        currentValue = buyingAsset.gramWeight! * pureGoldRatio * goldPrice;
      }
    } else {
      // NORMAL VARLIK HESAPLAMASI
      final assetData = currencyResponse.currencies[buyingAsset.assetType];
      currentPrice = assetData?.buying ?? 0.0;
      currentValue = buyingAsset.quantity * currentPrice;
    }

    // Kar/zarar
    final change = currentValue - totalInvested;
    final changePercentage =
        totalInvested > 0 ? (change / totalInvested) * 100 : 0.0;

    return UserAssetModel(
      id: buyingAsset.id,
      assetType: buyingAsset.assetType,
      displayName: _getDisplayName(buyingAsset),
      quantity: buyingAsset.quantity,
      averagePrice: buyingAsset.buyingPrice,
      currentPrice: currentPrice,
      currentValue: currentValue,
      change: change,
      changePercentage: changePercentage,
      icon: _getAssetIcon(buyingAsset.assetType),
      lastUpdated: DateTime.now(),
      isBracelet: buyingAsset.isBracelet,
      ayarType: buyingAsset.ayarType,
      gramWeight: buyingAsset.gramWeight,
    );
  }

  /// Display name belirleme
  static String _getDisplayName(BuyingAssetModel buyingAsset) {
    if (buyingAsset.isBracelet &&
        buyingAsset.ayarType != null &&
        buyingAsset.gramWeight != null) {
      return '${buyingAsset.ayarType} Ayar Bilezik (${buyingAsset.gramWeight!.toStringAsFixed(1)}g)';
    }

    // Basit isimlendirme
    switch (buyingAsset.assetType) {
      case 'ALTIN':
        return 'Altın';
      case 'USDTRY':
        return 'Dolar';
      case 'EURTRY':
        return 'Euro';
      case 'GBPTRY':
        return 'Sterlin';
      case 'AYAR14':
        return '14 Ayar Altın';
      case 'AYAR22':
        return '22 Ayar Altın';
      default:
        return buyingAsset.assetType;
    }
  }

  /// İkon belirleme
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

  /// UI için formatlanmış değerler
  bool get isProfitable => change > 0;
  String get formattedChange =>
      '${change > 0 ? '+' : ''}₺${change.toStringAsFixed(2)}';
  String get formattedChangePercentage =>
      '${changePercentage > 0 ? '+' : ''}${changePercentage.toStringAsFixed(2)}%';
  String get formattedCurrentValue => '₺${currentValue.toStringAsFixed(2)}';
}
