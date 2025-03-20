import 'package:asset_tracker/features/currencyAssets/data/data_source/remote/abstract_currency_asset_service.dart';
import 'package:asset_tracker/features/currencyAssets/data/models/currecy_asset_model.dart';
import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyAssetFirestoreServiceImpl implements ICurrencyAssetService {
  final FirebaseFirestore _firestore;

  CurrencyAssetFirestoreServiceImpl(this._firestore);

  @override
  Future<bool> deleteCurrencyAsset(String assetId) {
    final assetRef = _firestore.collection('assets').doc(assetId);
    return assetRef.delete().then((value) => true).catchError((error) => false);
  }

  @override
  Future<List<CurrencyAssetEntity>> getCurrencyAssets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('assets')
          .where('userId', isEqualTo: userId) // userId'ye göre filtreleme
          .get();

      // Filtrelenmiş verileri döndürüyoruz
      return snapshot.docs.map((assetDoc) {
        final data = assetDoc.data();
        return CurrencyAssetModel(
          id: assetDoc.id, // Firestore'dan gelen belge id'sini kullanıyoruz
          assetType: data['assetType'] ?? '',
          buyingDate: data['buyingDate'] is String
              ? DateTime.parse(data['buyingDate'])
              : DateTime.now(),
          buyingPrice: (data['buyingPrice'] as num?)?.toDouble() ?? 0.0,
          quantity: (data['quantity'] as num?)?.toDouble() ?? 0.0,
          userId: data['userId'] ?? '',
        );
      }).toList();
    } catch (error) {
      // Hata durumunda boş liste döndürebiliriz
      return [];
    }
  }

  @override
  Future<bool> updateCurrencyAsset(CurrencyAssetEntity asset) {
    final assetRef = _firestore.collection('assets').doc(asset.id);
    return assetRef
        .update(asset.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }
}
