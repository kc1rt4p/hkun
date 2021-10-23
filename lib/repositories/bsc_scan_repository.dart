import 'package:hkun/services/api_service.dart';

class BscScanRepository {
  final _apiService = ApiService('bscScan');
  final apikey = 'WRZ9TPRDIURU9AJF4UZDU9REK6C4NZW4DA';

  Future<double> getHkunBalance(String address) async {
    final response = await _apiService.get(
      url: '',
      queryParameters: {
        'module': 'account',
        'action': 'tokenbalance',
        'contractaddress': '0xbb2fa5b2d19209f4cf50cf745efc32641a7c9fb1',
        'address': address,
        'tag': 'latest',
        'apikey': apikey,
      },
    );

    return int.parse(response.data['result'] as String) / 1000000000;
  }

  Future<num> getHkunCSupply() async {
    final response = await _apiService.get(
      url: '',
      queryParameters: {
        'module': 'stats',
        'action': 'tokenCsupply',
        'contractaddress': '0xbb2fa5b2d19209f4cf50cf745efc32641a7c9fb1',
        'apikey': apikey,
      },
    );

    return num.parse(response.data['result']) / 1000000000;
  }
}
