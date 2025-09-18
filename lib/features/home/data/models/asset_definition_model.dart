import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';

class AssetDefinitionModel {
  final String id; // Veri kodu: ALTIN, EURTRY, vb.
  final String displayName; // Kullanıcıya gösterilecek isim
  final bool isSelectable; // Kullanıcı ekleyebilir mi? (EURUSD ve ONS false)
  final bool isVisible; // Ana sayfada gösterilecek mi?
  final AssetType type; // Altın, Döviz, Bilezik gibi tür bilgisi
  final String symbol; // Görsel sembol (AU, €, $ vs.)

  const AssetDefinitionModel({
    required this.id,
    required this.displayName,
    required this.isSelectable,
    required this.isVisible,
    required this.type,
    required this.symbol,
  });
}
