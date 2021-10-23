import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/screens/home/home_screen.dart';
import 'package:hkun/screens/markets/markets_screen.dart';

class CoinDetailsScreen extends StatefulWidget {
  final MarketDataModel coin;
  const CoinDetailsScreen({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinDetailsScreenState createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  late MarketDataModel _coin;

  @override
  void initState() {
    setState(() {
      _coin = widget.coin;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: SizeConfig.paddingTop),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.grey,
                      size: 18.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Coin Details',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '${_coin.current_price} USD',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.25,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            // Text(
                            //   'Bogged',
                            //   style: TextStyle(
                            //     color: Color(0xFF8C8F95),
                            //   ),
                            // ),
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
                                  '${_coin.price_change_percentage_24h!.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _coin.price_change_percentage_24h! > 0
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
                          '${_coin.price_change_24h} USD (24h)',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: _coin.price_change_24h! > 0
                                ? Color(0xFF219653)
                                : Colors.red.shade400,
                          ),
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
                            gridLineLabelPrecision: 6,
                            gridLineLabelColor: Color(0xFF7A7585),
                            gridLinelabelPrefix: '\$',
                            gridLineWidth: 0.1,
                            gridLineColor: Color(0xFFC4C4C4),
                            gridLineAmount: 4,
                            enableGridLines: true,
                            lineGradient: gradientColor,
                            data: _coin.sparkline_in_7d!,
                          ),
                        ),
                      ),
                      _buildPriceRange(),
                      SizedBox(height: 24.0),
                      _buildCoinDetailItem(
                        label: 'Market Cap',
                        value: _coin.market_cap != null
                            ? '\$${oCcy2.format(_coin.market_cap)}'
                            : '?',
                      ),
                      _buildCoinDetailItem(
                        label: '24H Trading Volume',
                        value: _coin.total_volume != null
                            ? '\$${oCcy2.format(_coin.total_volume)}'
                            : '?',
                      ),
                      _buildCoinDetailItem(
                        label: 'Fully Diluted Violation',
                        value: _coin.fully_diluted_valuation != null
                            ? '\$${oCcy2.format(_coin.fully_diluted_valuation)}'
                            : '?',
                      ),
                      _buildCoinDetailItem(
                        label: 'Circulating Supply',
                        value: _coin.circulating_supply != null
                            ? oCcy2.format(_coin.circulating_supply!)
                            : '?',
                      ),
                      _buildCoinDetailItem(
                        label: 'Total Supply',
                        value: _coin.total_supply != null
                            ? oCcy2.format(_coin.total_supply!)
                            : '?',
                      ),
                      _buildCoinDetailItem(
                        label: 'Max Supply',
                        value: _coin.max_supply != null
                            ? oCcy2.format(_coin.max_supply!)
                            : '?',
                      ),
                    ],
                  ),
                ),
              ),
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

  Widget _buildPriceRange() {
    final width = (SizeConfig.screenWidth - 32) *
        (_coin.current_price! / _coin.high_24h!);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16.0),
          child: Stack(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFF1C1C1E),
                ),
              ),
              Container(
                width: width,
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
                  '\$${oCcy.format(_coin.low_24h)}',
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
                    '\$${oCcy.format(_coin.high_24h)}',
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
