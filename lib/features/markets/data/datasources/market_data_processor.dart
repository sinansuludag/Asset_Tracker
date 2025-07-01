import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/markets/data/models/market_model.dart';

class MarketDataProcessor {
  static List<MarketModel> processMarketsFromCurrency(
      CurrencyResponse currencyResponse) {
    final List<MarketModel> markets = [];

    currencyResponse.currencies.forEach((code, currencyData) {
      final market = MarketModel.fromCurrencyData(code, currencyData);
      markets.add(market);
    });

    return markets;
  }

  static List<MarketModel> filterMarkets(
      List<MarketModel> markets, String category) {
    if (category == 'all') return markets;
    return markets.where((market) => market.category == category).toList();
  }

  static List<MarketModel> searchMarkets(
      List<MarketModel> markets, String query) {
    if (query.isEmpty) return markets;

    final lowercaseQuery = query.toLowerCase();
    return markets.where((market) {
      return market.name.toLowerCase().contains(lowercaseQuery) ||
          market.code.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static List<MarketModel> sortMarkets(
      List<MarketModel> markets, String sortBy, bool ascending) {
    final sortedMarkets = List<MarketModel>.from(markets);

    sortedMarkets.sort((a, b) {
      int result;
      switch (sortBy) {
        case 'name':
          result = a.name.compareTo(b.name);
          break;
        case 'price':
          result = a.currentPrice.compareTo(b.currentPrice);
          break;
        case 'change':
          result = a.changePercentage.compareTo(b.changePercentage);
          break;
        case 'volume':
          result = a.volume.compareTo(b.volume);
          break;
        default:
          result = a.name.compareTo(b.name);
      }
      return ascending ? result : -result;
    });

    return sortedMarkets;
  }

  static List<MarketModel> getTrendingMarkets(List<MarketModel> markets) {
    return markets.where((market) => market.isTrending).toList();
  }

  static Map<String, double> getMarketSummary(List<MarketModel> markets) {
    final totalMarkets = markets.length;
    final positiveMarkets = markets.where((m) => m.change > 0).length;
    final negativeMarkets = markets.where((m) => m.change < 0).length;
    final avgChange = markets.isNotEmpty
        ? markets.map((m) => m.changePercentage).reduce((a, b) => a + b) /
            markets.length
        : 0.0;

    return {
      'totalMarkets': totalMarkets.toDouble(),
      'positiveMarkets': positiveMarkets.toDouble(),
      'negativeMarkets': negativeMarkets.toDouble(),
      'avgChange': avgChange,
    };
  }
}
