import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

/// WebSocket servisi için soyut sınıf tanımı
abstract class ICurrencyWebSocketService {
  Stream<CurrencyResponse> connectEndListen();
  void disconnect();
}
