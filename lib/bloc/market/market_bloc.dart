import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/repositories/coin_gecko_repository.dart';
import 'package:hkun/repositories/news_repository.dart';
import 'package:meta/meta.dart';

part 'market_event.dart';
part 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketInitial());

  final _coinGeckoRepository = CoinGeckoRepository();
  final _newsRepository = NewsRepository();

  @override
  Stream<MarketState> mapEventToState(
    MarketEvent event,
  ) async* {
    try {
      if (event is GetTopCoins) {
        yield LoadingMarket();
        final news = await _newsRepository.getNews();
        final hkunInfo = await _coinGeckoRepository.getHkunInfo();
        final list =
            await _coinGeckoRepository.getTopCoins(withSparkline: true);
        yield GetTopCoinsDone(
            list, news.map((n) => n.imgUrl!).toList(), news[0], hkunInfo);
      }

      if (event is GetTopCoinsWithSparkline) {
        yield LoadingMarket();
        final list =
            await _coinGeckoRepository.getTopCoins(withSparkline: true);
        final globalMarketCap =
            await _coinGeckoRepository.getGlobalMarketInfo();
        yield GetTopCoinsWithSparklineDone(list, globalMarketCap);
      }
    } catch (e) {
      yield ErrorMarket(e.toString());
    }
  }
}
