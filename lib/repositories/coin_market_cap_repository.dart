import 'package:hkun/services/api_service.dart';

class CoinMarketCapRepository {
  final _apiService = ApiService('coinMarketCap');

  Future<num> getHkunMarketCap() async {
    final response = await _apiService.get(
      url: 'include/market_cap.php',
    );

    return num.parse(response.data);
  }

  Future<num> getHkunCSupply() async {
    final response = await _apiService.get(
      url: 'include/circulating_supply.php',
    );

    return num.parse(response.data);
  }
}
