class AssetEntity {
  final String id;
  final String assetType;
  final DateTime buyingDate;
  final double buyingPrice;
  final int quantity;
  final String userId;

  AssetEntity({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
    required this.userId,
  });

  AssetEntity copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    int? quantity,
    String? userId,
  }) {
    return AssetEntity(
      id: id ?? this.id,
      assetType: assetType ?? this.assetType,
      buyingDate: buyingDate ?? this.buyingDate,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
    );
  }

  factory AssetEntity.fromJson(Map<String, dynamic> json) {
    return AssetEntity(
      id: json['id'] ?? '',
      assetType: json['assetType'] ?? '',
      buyingDate: json['buyingDate'] != null
          ? DateTime.parse(json['buyingDate'])
          : DateTime.now(),
      buyingPrice: json['buyingPrice'] != null
          ? (json['buyingPrice'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetType': assetType,
      'buyingDate': buyingDate.toIso8601String(),
      'buyingPrice': buyingPrice,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
