import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';

class CurrencyRepositoryImpl implements ICurrencyRepository {
  final ICurrencyWebSocketService _webSocketService;

  CurrencyRepositoryImpl(this._webSocketService);

  @override
  Stream<CurrencyResponse> getCurrencyUpdates() {
    return _webSocketService.connectEndListen();
  }
}
