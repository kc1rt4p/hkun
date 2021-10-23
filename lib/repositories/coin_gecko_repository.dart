import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/services/api_service.dart';
import 'package:hkun/services/endpoints.dart';

class CoinGeckoRepository {
  final _apiService = ApiService('coinGecko');

  Future<List<MarketDataModel>> getTopCoins({withSparkline = false}) async {
    final response = await _apiService.get(
      url: Endpoint.MARKETS,
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': '10',
        'page': 1,
        'sparkline': withSparkline,
      },
    );

    return (response.data as List<dynamic>)
        .map((item) => MarketDataModel.fromJson(item))
        .toList();
  }

  Future<dynamic> getGlobalMarketInfo() async {
    final response = await _apiService.get(url: Endpoint.GLOBAL);

    return response.data;
  }

  Future<MarketDataModel> getHkunInfo() async {
    final response = await _apiService.get(
      url: Endpoint.COIN_CURRENT_DATA.replaceAll('{id}', 'hakunamatata-new'),
      queryParameters: {
        'tickers': false,
        'localization': false,
        'community_data': false,
        'developer_data': false,
        'sparkline': true,
      },
    );

    return MarketDataModel.fromJson2(response.data);
  }
}
