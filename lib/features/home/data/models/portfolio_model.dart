import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';

class PortfolioModel {
  final double totalValue;
  final double totalChange;
  final double changePercentage;
  final List<UserAssetModel> assets;
  final bool isLoading;
  final bool hasError;

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
