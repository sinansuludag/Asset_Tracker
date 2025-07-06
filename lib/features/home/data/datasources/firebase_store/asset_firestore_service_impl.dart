import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Firestore ile varlık kaydetme işlemlerinin gerçek implementasyonu
class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;

  AssetFirestoreServiceImpl(this._firestore);

  @override
  Future<bool> saveAsset(AssetEntity asset) {
    // 1. Yeni bir document ID oluştur
    final id = _firestore.collection('assets').doc().id;
    // 2. Asset referansını al
    final assetRef = _firestore.collection('assets').doc(id);
    final newAsset =
        asset.copyWith(id: id); // Yeni ID ile yeni bir nesne oluştur

    // 3. Firestore'a kaydet
    return assetRef
        .set(newAsset.toJson())
        .then((value) => true) // Başarılı ise true döner
        .catchError((error) => false); // Hata durumunda false döner
  }
}
