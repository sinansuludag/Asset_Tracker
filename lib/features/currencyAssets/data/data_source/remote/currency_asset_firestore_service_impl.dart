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
  Future<CurrencyAssetEntity?> getCurrencyAsset(String assetId) {
    return _firestore.collection('assets').doc(assetId).get().then((assetDoc) {
      if (assetDoc.exists) {
        final data = assetDoc.data();
        return CurrencyAssetModel(
          id: assetId,
          assetType: data?['assetType'] ?? '',
          buyingDate:
              (data?['buyingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          buyingPrice: data?['buyingPrice'] ?? 0.0,
          quantity: data?['quantity'] ?? 0,
          userId: data?['userId'] ?? '',
        );
      } else {
        return null;
      }
    });
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
