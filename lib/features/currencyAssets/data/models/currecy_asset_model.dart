import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';

class CurrencyAssetModel extends CurrencyAssetEntity {
  CurrencyAssetModel({
    required super.id,
    required super.assetType,
    required super.buyingDate,
    required super.buyingPrice,
    required super.quantity,
    required super.userId,
  });

  @override
  CurrencyAssetModel copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
  }) {
    return CurrencyAssetModel(
      id: id ?? this.id,
      assetType: assetType ?? this.assetType,
      buyingDate: buyingDate ?? this.buyingDate,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
    );
  }

  factory CurrencyAssetModel.fromJson(Map<String, dynamic> json) {
    return CurrencyAssetModel(
      id: json['id'] ?? '',
      assetType: json['assetType'] ?? '',
      buyingDate: json['buyingDate'] != null
          ? DateTime.parse(json['buyingDate'])
          : DateTime.now(),
      buyingPrice: json['buyingPrice'] != null
          ? (json['buyingPrice'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0.0,
      userId: json['userId'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetType': assetType,
      'buyingDate': buyingDate.toIso8601String(),
      'buyingPrice': buyingPrice,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
