class AssetModel {
  final String id;
  final String assetType;
  final DateTime buyingDate;
  final double buyingPrice;
  final int quantity;

  AssetModel({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] ?? '',
      assetType: json['assetType'] ?? '',
      buyingDate: json['buyingDate'] != null
          ? DateTime.parse(json['buyingDate'])
          : DateTime.now(),
      buyingPrice: json['buyingPrice'] != null
          ? (json['buyingPrice'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0,
    );
  }

  // Nesneyi JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetType': assetType,
      'buyingDate': buyingDate.toIso8601String(),
      'buyingPrice': buyingPrice,
      'quantity': quantity,
    };
  }
}

// import 'package:json_annotation/json_annotation.dart';

// part 'asset_model.g.dart'; // Kod üretilecek dosya

// @JsonSerializable()
// class AssetModel {
//   final String id;
//   final String assetType;
//   final DateTime buyingDate;
//   final double buyingPrice;
//   final int quantity;

//   AssetModel({
//     required this.id,
//     required this.assetType,
//     required this.buyingDate,
//     required this.buyingPrice,
//     required this.quantity,
//   });

//   /// JSON'dan nesne oluşturma
//   factory AssetModel.fromJson(Map<String, dynamic> json) =>
//       _$AssetModelFromJson(json);

//   /// Nesneyi JSON'a çevirme
//   Map<String, dynamic> toJson() => _$AssetModelToJson(this);
// }
