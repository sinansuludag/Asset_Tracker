class AssetModel {
  final String id;
  final String assetType;
  final DateTime buyingDate;
  final double buyingPrice;
  final int quantity;
  final String userId;
  final String userName;

  AssetModel({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
    required this.userId,
    required this.userName,
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
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetType': assetType,
      'buyingDate': buyingDate.toIso8601String(),
      'buyingPrice': buyingPrice,
      'quantity': quantity,
      'userId': userId,
      'userName': userName,
    };
  }
}
