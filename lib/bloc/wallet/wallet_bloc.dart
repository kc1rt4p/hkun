import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/repositories/bsc_scan_repository.dart';
import 'package:hkun/repositories/coin_gecko_repository.dart';
import 'package:hkun/repositories/coin_market_cap_repository.dart';
import 'package:meta/meta.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial());

  final _storage = GetStorage();
  final _bscScanRepository = BscScanRepository();
  final _coinGeckoRepository = CoinGeckoRepository();
  final _coinMarketCapRepository = CoinMarketCapRepository();

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    try {
      if (event is InitializeWallet) {
        yield WalletLoading();
        final address = _storage.read<String>('hkun_address');

        if (address == null || address.isEmpty) {
          yield PromptWalletAddress();
        } else {
          final hkunBalance = await _bscScanRepository.getHkunBalance(address);
          final hkunInfo = await _coinGeckoRepository.getHkunInfo();
          final marketCap = await _coinMarketCapRepository.getHkunMarketCap();
          final cSupply = await _coinMarketCapRepository.getHkunCSupply();
          hkunInfo.market_cap = marketCap.toInt();
          hkunInfo.circulating_supply = cSupply.toDouble();

          yield InitializeWalletDone(hkunBalance, hkunInfo);
        }
      }

      if (event is AddWalletAddress) {
        await _storage.write('hkun_address', event.walletAddress);
        add(InitializeWallet());
      }

      if (event is EnterWalletAddress) {
        yield PromptWalletAddress();
      }
    } catch (e) {
      yield WalletError(e.toString());
    }
  }

  @override
  Future<void> close() {
    _storage.erase();
    return super.close();
  }
}
