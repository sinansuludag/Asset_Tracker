// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyARehx9mUP1quSb-Ys0OGKdLbLOj8SfL-k',
      appId: '1:61091765288:android:8ff702ecfa45b442a9291d',
      messagingSenderId: '61091765288',
      projectId: 'assettrackerapp-c16d8',
      storageBucket: 'assettrackerapp-c16d8.appspot.com', // Storage Bucket
      authDomain: 'assettrackerapp-c16d8.firebaseapp.com', // Auth Domain
    );
  }
}
