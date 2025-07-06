/// Varlık entity'si - pure business object
abstract class AssetEntity {
  final String id; // Benzersiz ID
  final String assetType; // Varlık türü
  final DateTime buyingDate; // Alış tarihi
  final double buyingPrice; // Alış fiyatı
  final double quantity; // Miktar
  final String userId; // Kullanıcı ID'si

  const AssetEntity({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
    required this.userId,
  });

  Map<String, dynamic> toJson();

  /// Soyut `copyWith` metodu
  AssetEntity copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
  });
}
