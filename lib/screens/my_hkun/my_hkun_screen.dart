import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hkun/bloc/wallet/wallet_bloc.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/screens/home/home_screen.dart';
import 'package:hkun/screens/markets/markets_screen.dart';
import 'package:hkun/services/launcher_service.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:hkun/widgets/gradient_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHKUNScreen extends StatefulWidget {
  const MyHKUNScreen({Key? key}) : super(key: key);

  @override
  _MyHKUNScreenState createState() => _MyHKUNScreenState();
}

class _MyHKUNScreenState extends State<MyHKUNScreen> {
  late WalletBloc _walletBloc;

  MarketDataModel? _hkunInfo;

  num _hkunBalance = 0;

  bool _isLoading = false;

  final _refController = RefreshController();

  @override
  void initState() {
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _walletBloc.add(InitializeWallet());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener(
      bloc: _walletBloc,
      listener: (context, state) {
        print('wallet bloc state (wallet screen): $state');
        if (state is WalletLoading) {
          setState(() {
            _isLoading = true;
          });
          Dialogs.showLoadingDialog(context);
        }

        if (state is InitializeWalletDone) {
          setState(() {
            _hkunBalance = state.hkunBalance;
            _hkunInfo = state.hkunInfo;
          });
          Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
        }

        if (state is PromptWalletAddress) {
          if (_isLoading) {
            Navigator.pop(context);
            setState(() {
              _isLoading = false;
            });
          }
          _promptUserWalletAddress(context);
        }

        if (state is WalletError) {
          print('error on wallet: ${state.message}');
        }
      },
      child: _hkunInfo != null
          ? SmartRefresher(
              onRefresh: () {
                _walletBloc.add(InitializeWallet());
                _refController.refreshCompleted();
              },
              controller: _refController,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            '${_hkunInfo!.current_price} USD',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.25,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Color(0xFF1C1C1E),
                            ),
                            child: Center(
                              child: Text(
                                '${_hkunInfo!.price_change_percentage_24h!.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _hkunInfo!.price_change_percentage_24h! >
                                              0
                                          ? Colors.white
                                          : Colors.red.shade400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 27.0),
                      child: Text(
                        '${_hkunInfo!.price_change_24h} USD (24h)',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: _hkunInfo!.price_change_24h! > 0
                              ? Color(0xFF219653)
                              : Colors.red.shade400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => LauncherService.launchPooCoin(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/poocoin.png',
                                      width: 15.0,
                                      height: 15.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Poocoin',
                                      style: TextStyle(
                                        color: Color(0xFFE0E0E0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 9.0),
                          Expanded(
                            child: InkWell(
                              onTap: () => LauncherService.launchBogged(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/boggedfinance.png',
                                      width: 15.0,
                                      height: 15.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'Bogged',
                                      style: TextStyle(
                                        color: Color(0xFFE0E0E0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 24.0),
                      padding: EdgeInsets.fromLTRB(10.0, 21.0, 10.0, 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(10.42),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Sparkline(
                          gridLineLabelPrecision: 2,
                          gridLineLabelColor: Color(0xFF7A7585),
                          gridLinelabelPrefix: '\$',
                          gridLineWidth: 0.1,
                          gridLineColor: Color(0xFFC4C4C4),
                          gridLineAmount: 4,
                          enableGridLines: true,
                          lineGradient: gradientColor,
                          data: _hkunInfo!.sparkline_in_7d!,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 27.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'My Holdings',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _hkunBalance > 0
                                    ? oCcy2.format(_hkunBalance)
                                    : '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: GradientText(
                                  'HKUN',
                                  gradient: gradientColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${oCcy.format(_hkunBalance * _hkunInfo!.current_price!)}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                          Container(
                            width: (SizeConfig.screenWidth - 32) *
                                (_hkunInfo!.current_price! /
                                    _hkunInfo!.high_24h!),
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: gradientColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${_hkunInfo!.low_24h}',
                              style: TextStyle(
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '24H Range',
                                style: TextStyle(
                                  color: Color(0xFFBDBDBD),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$${_hkunInfo!.high_24h}',
                                style: TextStyle(
                                  color: Color(0xFFBDBDBD),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    _buildCoinDetailItem(
                      label: 'Market Cap',
                      value: _hkunInfo!.market_cap != null
                          ? '\$${oCcy2.format(_hkunInfo!.market_cap)}'
                          : '?',
                    ),
                    _buildCoinDetailItem(
                      label: '24H Trading Volume',
                      value: _hkunInfo!.total_volume != null
                          ? '\$${oCcy2.format(_hkunInfo!.total_volume)}'
                          : '?',
                    ),
                    _buildCoinDetailItem(
                      label: 'Circulating Supply',
                      value: _hkunInfo!.circulating_supply != null
                          ? oCcy2.format(_hkunInfo!.circulating_supply)
                          : '?',
                    ),
                    _buildCoinDetailItem(
                      label: 'All-Time High',
                      value:
                          _hkunInfo!.ath != null ? '\$${_hkunInfo!.ath!}' : '?',
                    ),
                    SizedBox(height: 12.0),
                    InkWell(
                      onTap: () => LauncherService.launchPooCoin(),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: gradientColor,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'Buy HKUN',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => LauncherService.launchClaimBUSD(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: gradientColor,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black,
                          ),
                          margin: EdgeInsets.all(1.0),
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Center(
                            child: GradientText(
                              'Claim your HKUN',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              gradient: gradientColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your HKUN wallet address',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Tap the wallet icon at the top.',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _promptUserWalletAddress(BuildContext context) async {
    final address = await Dialogs.promptUserWalletAddress(context);
    if (address == null || address.isEmpty) return;
    _walletBloc.add(AddWalletAddress(address));
  }

  Widget _buildCoinDetailItem({
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 17.0),
          Container(
            height: 0.1,
            width: double.infinity,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
