import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hkun/bloc/market/market_bloc.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'coin_details_screen.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");
final oCcy2 = new NumberFormat("#,##0", "en_US");

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({Key? key}) : super(key: key);

  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final _marketBloc = MarketBloc();
  String _selectedInterval = '1d';
  List<MarketDataModel> _coinList = [];
  num totalMarketCap = 0;
  num totalMarketVolume = 0;
  num changePercentage = 0;

  final _refController = RefreshController();

  @override
  void initState() {
    _marketBloc.add(GetTopCoinsWithSparkline(_selectedInterval));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer(
      bloc: _marketBloc,
      listener: (context, state) {
        if (state is LoadingMarket) {
          Dialogs.showLoadingDialog(context);
        } else {
          Navigator.pop(context);
        }

        if (state is GetTopCoinsWithSparklineDone) {
          setState(() {
            _coinList = state.list;
          });

          final Map<String, dynamic> globalMarketInfo = state.globalMarketCap;
          setState(() {
            totalMarketCap = ((globalMarketInfo['data']
                    as Map<String, dynamic>)['total_market_cap']
                as Map<String, dynamic>)['usd'] as double;
            totalMarketVolume = ((globalMarketInfo['data']
                    as Map<String, dynamic>)['total_volume']
                as Map<String, dynamic>)['usd'] as double;
            changePercentage = (globalMarketInfo['data'] as Map<String,
                dynamic>)['market_cap_change_percentage_24h_usd'] as double;
            print(changePercentage);
          });
        }
      },
      builder: (context, state) {
        return SmartRefresher(
          onRefresh: () {
            _marketBloc.add(GetTopCoinsWithSparkline(_selectedInterval));
            _refController.refreshCompleted();
          },
          controller: _refController,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Global Cryptocurrency',
                  style: TextStyle(
                    color: Color(0xFF96969A),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 24.0),
                  padding: EdgeInsets.fromLTRB(12.0, 20.0, 24.0, 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(10.42),
                  ),
                  child: Column(
                    children: [
                      _buildCoinDetailItem(
                        label: 'Market Capitalization',
                        value: '\$${oCcy.format(totalMarketCap)}',
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        height: 0.1,
                        margin: EdgeInsets.only(bottom: 5.0),
                      ),
                      _buildCoinDetailItem(
                        label: 'Market Volume',
                        value: '\$${oCcy.format(totalMarketVolume)}',
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        height: 0.2,
                        margin: EdgeInsets.only(bottom: 5.0),
                      ),
                      _buildCoinDetailItem(
                        label: '24H Change Percentage',
                        value: '${changePercentage.toStringAsFixed(2)}%',
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coin Rankings',
                      style: TextStyle(
                        color: Color(0xFF96969A),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 24.0),
                      padding: EdgeInsets.fromLTRB(12.0, 20.0, 24.0, 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(10.42),
                      ),
                      child: Column(
                        children: [
                          ..._coinList
                              .map(
                                (coin) => _buildCoinItem(coin),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildIntervalBtn({
  //   required String label,
  // }) {
  //   return GestureDetector(
  //     onTap: () => setState(() => _selectedInterval = label),
  //     child: Text(
  //       label.toUpperCase(),
  //       style: TextStyle(
  //         color: _selectedInterval != label ? Color(0xFF7A7585) : Colors.white,
  //         fontSize: 14.58,
  //         letterSpacing: 0.16,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCoinItem(MarketDataModel coin) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoinDetailsScreen(coin: coin))),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: coin.image ?? '',
                  height: 30.0,
                  width: 30.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name ?? '',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        coin.symbol!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${oCcy.format(coin.current_price ?? 0)}',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(coin.price_change_percentage_24h ?? 0).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: coin.price_change_percentage_24h! > 0
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.white10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinDetailItem({
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.28,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 15.0,
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
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
