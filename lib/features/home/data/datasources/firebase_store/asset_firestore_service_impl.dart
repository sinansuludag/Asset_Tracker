import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;

  AssetFirestoreServiceImpl(this._firestore);

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
}
