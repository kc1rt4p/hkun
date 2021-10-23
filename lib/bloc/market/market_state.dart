part of 'market_bloc.dart';

@immutable
abstract class MarketState {}

class MarketInitial extends MarketState {}

class GetTopCoinsDone extends MarketState {
  final List<MarketDataModel> list;
  final List<String> imageUrls;
  final NewsModel latestNews;
  final MarketDataModel hkunInfo;

  GetTopCoinsDone(this.list, this.imageUrls, this.latestNews, this.hkunInfo);
}

class GetTopCoinsWithSparklineDone extends MarketState {
  final List<MarketDataModel> list;
  final dynamic globalMarketCap;

  GetTopCoinsWithSparklineDone(this.list, this.globalMarketCap);
}

class ErrorMarket extends MarketState {
  final String message;

  ErrorMarket(this.message);
}

class LoadingMarket extends MarketState {}
