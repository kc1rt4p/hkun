part of 'market_bloc.dart';

@immutable
abstract class MarketEvent {}

class GetTopCoins extends MarketEvent {}

class GetTopCoinsWithSparkline extends MarketEvent {
  final String duration;

  GetTopCoinsWithSparkline(this.duration);
}
