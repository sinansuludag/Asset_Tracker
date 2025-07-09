import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';

/// İzinli varlıklar servisi - issue'deki exact listeyi yönetir
/// Bu servis sayesinde sadece belirlenen varlıklar gösterilir ve eklenebilir
class AllowedAssetsService {
  // Issue'den alınan exact varlık listesi - değiştirilmemeli!
  static const List<AssetDefinitionModel> _allowedAssets = [
    // ===== ALTIN GRUBU =====
    AssetDefinitionModel(
      id: 'ALTIN',
      displayName: 'Has Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      description: '%99 saf altın 999.99 yazar altın üzerinde',
      symbol: 'AU',
    ),
    AssetDefinitionModel(
      id: 'KULCEALTIN',
      displayName: '24 Ayar Gram Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '24K',
    ),
    AssetDefinitionModel(
      id: 'AYAR22',
      displayName: '22 Ayar Gram Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      description:
          'Gram olarak satıldığında üzerinde 995 yazar. Bileziklerde de kullanılır.',
      symbol: '22K',
    ),
    AssetDefinitionModel(
      id: 'AYAR14',
      displayName: '14 Ayar Gram Altın',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      description: 'Genelde bileziklerde ve takılarda kullanılır.',
      symbol: '14K',
    ),

    // ===== DÖVİZ GRUBU =====
    AssetDefinitionModel(
      id: 'EURTRY',
      displayName: 'Euro / TL',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      description: 'Ekranda sadece Euro da yazılabilir',
      symbol: '€',
    ),
    AssetDefinitionModel(
      id: 'EURUSD',
      displayName: 'Euro / USD',
      isSelectable: false, // ⚠️ Issue gereksinimi: Sadece gösterim!
      isVisible: true,
      type: AssetType.currency,
      description: 'Sadece gösterim. Kullanıcı ekleyemez.',
      symbol: 'EUR/USD',
    ),
    AssetDefinitionModel(
      id: 'GBPTRY',
      displayName: 'Sterlin / TL',
      isSelectable: true,
      isVisible: true,
      type: AssetType.currency,
      description: 'Ekranda sadece Sterlin veya benzer isim yazılabilir.',
      symbol: '£',
    ),

    // ===== ÖZEL ALTIN SİKKELERİ =====
    AssetDefinitionModel(
      id: 'CEYREK_YENI',
      displayName: 'Çeyrek Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/4',
    ),
    AssetDefinitionModel(
      id: 'CEYREK_ESKI',
      displayName: 'Çeyrek Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/4',
    ),
    AssetDefinitionModel(
      id: 'YARIM_YENI',
      displayName: 'Yarım Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/2',
    ),
    AssetDefinitionModel(
      id: 'YARIM_ESKI',
      displayName: 'Yarım Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1/2',
    ),
    AssetDefinitionModel(
      id: 'TEK_YENI',
      displayName: 'Tam Altın (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1',
    ),
    AssetDefinitionModel(
      id: 'TEK_ESKI',
      displayName: 'Tam Altın (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '1',
    ),
    AssetDefinitionModel(
      id: 'ATA_YENI',
      displayName: 'Ata Lira (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA_ESKI',
      displayName: 'Ata Lira (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: 'ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA5_YENI',
      displayName: 'Beşi Bir Yerde Ata(Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '5ATA',
    ),
    AssetDefinitionModel(
      id: 'ATA5_ESKI',
      displayName: 'Beşi Bir Yerde Ata (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      symbol: '5ATA',
    ),
    AssetDefinitionModel(
      id: 'GREMSE_YENI',
      displayName: 'Gremse (Yeni)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      description: 'Ziynet 2.5 Altın',
      symbol: 'GR',
    ),
    AssetDefinitionModel(
      id: 'GREMSE_ESKI',
      displayName: 'Gremse (Eski)',
      isSelectable: true,
      isVisible: true,
      type: AssetType.gold,
      description: 'Ziynet 2.5 Altın',
      symbol: 'GR',
    ),

    // ===== PLATİN =====
    AssetDefinitionModel(
      id: 'PLATIN',
      displayName: 'Platin',
      isSelectable: true,
      isVisible: true,
      type: AssetType.platinum,
      symbol: 'PT',
    ),

    // ===== SADECE GÖSTERİM (Kullanıcı ekleyemez) =====
    AssetDefinitionModel(
      id: 'ONS',
      displayName: 'Ons Altın',
      isSelectable: false, // ⚠️ Issue gereksinimi: Sadece gösterim!
      isVisible: true,
      type: AssetType.gold,
      description: 'Sadece gösterim. Kullanıcı Ekleyemez.',
      symbol: 'OZ',
    ),
  ];

  /// Tüm izinli varlıkları getir
  static List<AssetDefinitionModel> getAllowedAssets() {
    return List.from(_allowedAssets); // Immutable copy
  }

  /// Ana sayfada gösterilecek varlıkları getir (isVisible: true)
  static List<AssetDefinitionModel> getVisibleAssets() {
    return _allowedAssets.where((asset) => asset.isVisible).toList();
  }

  /// Kullanıcının ekleyebileceği varlıkları getir (isSelectable: true)
  /// EURUSD ve ONS burada olmayacak!
  static List<AssetDefinitionModel> getSelectableAssets() {
    return _allowedAssets.where((asset) => asset.isSelectable).toList();
  }

  /// Türe göre varlıkları getir (altın, döviz vs.)
  static List<AssetDefinitionModel> getAssetsByType(AssetType type) {
    return _allowedAssets.where((asset) => asset.type == type).toList();
  }

  /// ID'ye göre varlık getir
  static AssetDefinitionModel? getAssetById(String id) {
    try {
      return _allowedAssets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null; // Bulunamadı
    }
  }

  /// Varlığın eklenip eklenemeyeceğini kontrol et
  static bool canAddAsset(String assetId) {
    final asset = getAssetById(assetId);
    return asset?.isSelectable ?? false;
  }

  /// Ana sayfada gösterilecek öncelikli varlıklar (piyasa kartları için)
  static List<AssetDefinitionModel> getPriorityAssets() {
    final priorities = ['ALTIN', 'EURTRY', 'GBPTRY', 'PLATIN'];
    return priorities
        .map((id) => getAssetById(id))
        .where((asset) => asset != null)
        .cast<AssetDefinitionModel>()
        .toList();
  }

  /// Issue gereksinimi: Bilezik için ayar listesi
  static List<String> getBraceletAyarOptions() {
    return ['14', '22']; // Sadece 14 ve 22 ayar
  }
}
