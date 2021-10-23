class Endpoint {
  static const MARKETS = 'coins/markets';
  static const COIN_CURRENT_DATA = 'coins/{id}';
  static const COIN_HISTORY = 'coins/{id}/history';
  static const COIN_TICKERS = 'coins/{id}/tickers';
  static const COIN_MARKET_CHART = 'coins/{id}/market_chart';
  static const COIN_INFO_FROM_ADDRESS =
      'coins/{id}/contract/{contract_address}';
  static const GLOBAL = 'global';
}
