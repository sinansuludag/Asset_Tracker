import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

/// Repository interface - business logic'in data layer'dan bağımsız olması için
abstract class ICurrencyRepository {
  Stream<CurrencyResponse> getCurrencyUpdates();
  void disconnect();
}
