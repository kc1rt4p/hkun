import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hkun/services/http_logging.dart';

class ApiService {
  final String bscScanBaseUrl = 'https://api.bscscan.com/api';
  final String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3/';
  final String coinMarketCapBaseUrl =
      'https://dashboard.hakunamatatatoken.com/';

  late Dio _dio;

  ApiService(String api) {
    if (api == 'bscScan') {
      _dio = Dio(BaseOptions(
        baseUrl: bscScanBaseUrl,
      ));
    }
    if (api == 'coinGecko') {
      _dio = Dio(BaseOptions(
        baseUrl: coinGeckoBaseUrl,
      ));
    }
    if (api == 'coinMarketCap') {
      _dio = Dio(BaseOptions(
        baseUrl: coinMarketCapBaseUrl,
      ));
    }

    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<Response> get(
      {required String url,
      Map<String, dynamic>? header,
      Map<String, dynamic>? queryParameters}) async {
    return await _safeFetch(() => _dio.get(url,
        queryParameters: queryParameters, options: Options(headers: header)));
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
  }) async {
    return await _safeFetch(
      () => _dio.post(
        url,
        data: body,
        options: Options(headers: header),
      ),
    );
  }

  Future<Response> _safeFetch(Future<Response> Function() tryFetch) async {
    var response;
    try {
      response = await tryFetch();
    } catch (e) {
      throw e;
    }
    return response;
  }
}
