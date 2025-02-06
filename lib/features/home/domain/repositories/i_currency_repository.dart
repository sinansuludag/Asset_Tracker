import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

abstract class ICurrencyRepository {
  Stream<CurrencyResponse> getCurrencyUpdates();
}
