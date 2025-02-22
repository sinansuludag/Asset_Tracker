import 'package:asset_tracker/features/buying_asset/data/data_source/remote/abstract_asset_service.dart';
import 'package:asset_tracker/features/buying_asset/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;

  AssetFirestoreServiceImpl(this._firestore);

  @override
  Future<bool> deleteAsset(String assetId) {
    final assetRef = _firestore.collection('assets').doc(assetId);
    return assetRef.delete().then((value) => true).catchError((error) => false);
  }

  @override
  Future<AssetEntity?> getAsset(String assetId) {
    return _firestore.collection('assets').doc(assetId).get().then((assetDoc) {
      if (assetDoc.exists) {
        final data = assetDoc.data();
        return BuyingAssetModel(
          id: assetId,
          assetType: data?['assetType'] ?? '',
          buyingDate:
              (data?['buyingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          buyingPrice: data?['buyingPrice'] ?? 0,
          quantity: data?['quantity'] ?? 0,
          userId: data?['userId'] ?? '',
        );
      } else {
        return null;
      }
    });
  }

  @override
  Future<bool> saveAsset(AssetEntity asset) {
    final id = _firestore.collection('assets').doc().id; // Yeni ID oluştur
    final assetRef = _firestore.collection('assets').doc(id);
    final newAsset =
        asset.copyWith(id: id); // Yeni ID ile yeni bir nesne oluştur

    return assetRef
        .set(newAsset.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }

  @override
  Future<bool> updateAsset(AssetEntity asset) {
    final assetRef = _firestore.collection('assets').doc(asset.id);
    return assetRef
        .update(asset.toJson())
        .then((value) => true)
        .catchError((error) => false);
  }
}
