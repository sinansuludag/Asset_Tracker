import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IPortfolioService {
  Future<List<BuyingAssetModel>> getUserAssets();
  Stream<List<BuyingAssetModel>> getUserAssetsStream();
}

/// Kullanıcının portföy verilerini Firestore'dan çeken servis
class PortfolioFirestoreService implements IPortfolioService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PortfolioFirestoreService(this._firestore, this._auth);

  @override
  Future<List<BuyingAssetModel>> getUserAssets() async {
    final user = _auth.currentUser;
    if (user == null) return []; // Kullanıcı oturum açmamışsa boş liste döner

    try {
      // Firestore'dan sadece o kullanıcının varlıklarını çek
      final querySnapshot = await _firestore
          .collection('assets')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Her document'i BuyingAssetModel'e çevir
      return querySnapshot.docs
          .map((doc) => BuyingAssetModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching user assets: $e');
      return [];
    }
  }

  @override
  Stream<List<BuyingAssetModel>> getUserAssetsStream() {
    final user = _auth.currentUser;

    if (user == null) return Stream.value([]);
    // Gerçek zamanlı veri akışı sağlar
    return _firestore
        .collection('assets')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BuyingAssetModel.fromJson(doc.data()))
            .toList());
  }
}
