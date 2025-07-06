import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Kullanıcının satın aldığı varlıkları temsil eden model
class BuyingAssetModel extends AssetEntity {
  BuyingAssetModel({
    required super.id, // Varlık ID'si
    required super.assetType, // Varlık türü (ALTIN, USDTRY vs.)
    required super.buyingDate, // Alış tarihi
    required super.buyingPrice, // Alış fiyatı
    required super.quantity, // Miktar
    required super.userId, // Hangi kullanıcıya ait
  });

  @override
  BuyingAssetModel copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
  }) {
    return BuyingAssetModel(
      id: id ?? this.id,
      assetType: assetType ?? this.assetType,
      buyingDate: buyingDate ?? this.buyingDate,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
    );
  }

  // JSON'dan model oluşturma
  factory BuyingAssetModel.fromJson(Map<String, dynamic> json) {
    return BuyingAssetModel(
      id: json['id'] ?? '', // Varlık ID'si
      assetType: json['assetType'] ?? '', // Varlık türü (ALTIN, USDTRY vs.)
      buyingDate: json['buyingDate'] != null
          ? DateTime.parse(json['buyingDate']) // String'den DateTime'a çevir
          : DateTime.now(),
      buyingPrice: (json['buyingPrice'] as num).toDouble(), // Alış fiyatı
      quantity: json['quantity'] ?? 0.0, // Miktar
      userId: json['userId'] ?? '', // Hangi kullanıcıya ait
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
