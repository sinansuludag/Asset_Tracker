import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

/// BuyingAsset + güncel fiyat = UserAsset
class UserAssetModel {
  final String id;
  final String assetType;
  final String displayName;
  final double quantity;
  final double averagePrice;
  final double totalInvestment;
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
    required this.totalInvestment,
    required this.currentPrice,
    required this.currentValue,
    required this.change,
    required this.changePercentage,
    required this.icon,
    required this.lastUpdated,
  });

  /// NOT: Burada `currentData` ekran tarafında `b.assetType`'a göre gönderiliyor.
  /// AYAR14/AYAR22 için bu `currentData.buying` zaten 14K/22K **gram fiyatı**dır.
  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel assetModel,
    CurrencyData currentData,
  ) {
    // Güncel birim fiyat
    final currentPrice = currentData.buying ?? 0.0;

    // Güncel değer
    double currentValue;
    if (assetModel.isBracelet) {
      // Bilezik: AYAR14/AYAR22 gram fiyatı zaten ayarlı => saf’lık uygulama!
      final gram = assetModel.gramWeight ?? 0.0;
      currentValue = gram * currentPrice;
    } else {
      // Normal varlık
      currentValue = assetModel.quantity * currentPrice;
    }

    // Yatırılan tutar (kayıt anında hesaplanmış)
    final invested = assetModel.totalInvestment;

    // Kar/Zarar ve yüzde
    final change = currentValue - invested;
    final changePct = invested > 0 ? (change / invested) * 100 : 0.0;

    return UserAssetModel(
      id: assetModel.id,
      assetType: assetModel.assetType,
      displayName: assetModel.displayName,
      quantity: assetModel.quantity,
      averagePrice: assetModel.buyingPrice,
      totalInvestment: invested,
      currentPrice: currentPrice,
      currentValue: currentValue,
      change: change,
      changePercentage: changePct,
      icon: _getAssetIcon(assetModel.assetType),
      lastUpdated: DateTime.now(),
    );
  }

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
