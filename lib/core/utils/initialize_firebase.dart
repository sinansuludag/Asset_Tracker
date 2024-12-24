// lib/core/initialize_firebase.dart
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}
