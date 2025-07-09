import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';

/// Kullanıcının tüm portföyünü temsil eden model
/// Ana sayfa header'ında gösterilen özet bilgiler
class PortfolioModel {
  final double totalValue; // Toplam portföy değeri (₺)
  final double totalChange; // Toplam değişim (₺)
  final double changePercentage; // Toplam değişim yüzdesi (%)
  final List<UserAssetModel> assets; // Kullanıcının sahip olduğu varlıklar
  final bool isLoading; // Veri yükleniyor mu?
  final bool hasError; // Veri çekilirken hata oluştu mu?

  const PortfolioModel({
    required this.totalValue,
    required this.totalChange,
    required this.changePercentage,
    required this.assets,
    this.isLoading = false,
    this.hasError = false,
  });

  /// Başlangıç durumu (uygulama açılırken)
  factory PortfolioModel.initial() => const PortfolioModel(
        totalValue: 0.0,
        totalChange: 0.0,
        changePercentage: 0.0,
        assets: [],
        isLoading: true,
      );

  /// Immutable update için copyWith
  PortfolioModel copyWith({
    double? totalValue,
    double? totalChange,
    double? changePercentage,
    List<UserAssetModel>? assets,
    bool? isLoading,
    bool? hasError,
  }) {
    return PortfolioModel(
      totalValue: totalValue ?? this.totalValue,
      totalChange: totalChange ?? this.totalChange,
      changePercentage: changePercentage ?? this.changePercentage,
      assets: assets ?? this.assets,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  /// Varlıkları türe göre gruplama (portföy analizi için)
  Map<String, List<UserAssetModel>> get groupedAssets {
    final Map<String, List<UserAssetModel>> grouped = {};

    for (final asset in assets) {
      if (grouped[asset.assetType] == null) {
        grouped[asset.assetType] = [];
      }
      grouped[asset.assetType]!.add(asset);
    }

    return grouped;
  }

  /// En değerli varlık
  UserAssetModel? get mostValuableAsset {
    if (assets.isEmpty) return null;
    return assets.reduce((a, b) => a.currentValue > b.currentValue ? a : b);
  }

  /// En karlı varlık
  UserAssetModel? get mostProfitableAsset {
    if (assets.isEmpty) return null;
    return assets.reduce((a, b) => a.change > b.change ? a : b);
  }
}
