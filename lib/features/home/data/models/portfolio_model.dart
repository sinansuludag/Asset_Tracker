import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';

class PortfolioModel {
  final double totalValue; // Toplam portföy değeri
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

  factory PortfolioModel.initial() => const PortfolioModel(
        totalValue: 0.0,
        totalChange: 0.0,
        changePercentage: 0.0,
        assets: [],
        isLoading: true,
      );

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
}
