import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

abstract class ICurrencyWebSocketService {
  Stream<CurrencyResponse> connectEndListen();
  void disconnect();
}
