import 'package:asset_tracker/core/app/my_app.dart';
import 'package:asset_tracker/core/utils/initialize_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeFirebase();
  await dotenv.load(fileName: ".env");
  print(dotenv.env['WEBSOCKET_URL']);
  runApp(const ProviderScope(child: MyApp()));
}
