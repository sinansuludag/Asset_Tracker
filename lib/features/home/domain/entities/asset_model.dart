/// Varlık entity'si - pure business object (DDD pattern)
/// Firebase'de saklanacak temel varlık bilgileri
abstract class AssetEntity {
  final String id; // Benzersiz ID (Firebase doc ID)
  final String assetType; // Varlık türü (ALTIN, EURTRY vs.)
  final DateTime buyingDate; // Alış tarihi
  final double buyingPrice; // Alış fiyatı (TL)
  final double quantity; // Miktar (gram, adet vs.)
  final String userId; // Hangi kullanıcıya ait (Firebase Auth UID)

  const AssetEntity({
    required this.id,
    required this.assetType,
    required this.buyingDate,
    required this.buyingPrice,
    required this.quantity,
    required this.userId,
  });

  /// JSON serialization için abstract method
  Map<String, dynamic> toJson();

  /// Immutable update için abstract copyWith
  AssetEntity copyWith({
    String? id,
    String? assetType,
    DateTime? buyingDate,
    double? buyingPrice,
    double? quantity,
    String? userId,
  });
}
