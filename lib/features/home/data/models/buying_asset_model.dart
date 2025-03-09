import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

class BuyingAssetModel extends AssetEntity {
  BuyingAssetModel({
    required super.id,
    required super.assetType,
    required super.buyingDate,
    required super.buyingPrice,
    required super.quantity,
    required super.userId,
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

  factory BuyingAssetModel.fromJson(Map<String, dynamic> json) {
    return BuyingAssetModel(
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

// import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'buying_asset_model.g.dart'; // Kod üretilecek dosya

// @JsonSerializable()
// class BuyingAssetModel extends AssetModel {
//   BuyingAssetModel({
//     required String id,
//     required String assetType,
//     required DateTime buyingDate,
//     required double buyingPrice,
//     required int quantity,
//   }) : super(
//           id: id,
//           assetType: assetType,
//           buyingDate: buyingDate,
//           buyingPrice: buyingPrice,
//           quantity: quantity,
//         );

//   /// JSON'dan nesne oluşturma
//   factory BuyingAssetModel.fromJson(Map<String, dynamic> json) =>
//       _$BuyingAssetModelFromJson(json);

//   /// Nesneyi JSON'a çevirme
//   @override
//   Map<String, dynamic> toJson() => _$BuyingAssetModelToJson(this);
// }
