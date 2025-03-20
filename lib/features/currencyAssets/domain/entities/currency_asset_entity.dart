abstract class CurrencyAssetEntity {
  final String id;
  final String assetType;
  final DateTime buyingDate;
  final double buyingPrice;
  final double quantity;
  final String userId;

  const CurrencyAssetEntity({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
    required this.userId,
  });

  Map<String, dynamic> toJson();

  /// Soyut `copyWith` metodu
  CurrencyAssetEntity copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
  });
}
