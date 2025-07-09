import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

/// WebSocket servisi için abstract interface
/// Haremaltın sitesinden real-time döviz kurları çekimi
abstract class ICurrencyWebSocketService {
  /// WebSocket bağlantısı kurma ve veri akışını dinleme
  Stream<CurrencyResponse> connectEndListen();

  /// Bağlantıyı kapatma
  void disconnect();
}
