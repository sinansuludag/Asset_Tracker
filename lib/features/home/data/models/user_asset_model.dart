import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';

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

  factory UserAssetModel.fromBuyingAsset(
    BuyingAssetModel buyingAsset,
    CurrencyData currentData,
  ) {
    final currentPrice = currentData.buying ?? 0.0;
    final currentValue = buyingAsset.quantity * currentPrice;
    final totalInvested = buyingAsset.quantity * buyingAsset.buyingPrice;
    final change = currentValue - totalInvested;
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
