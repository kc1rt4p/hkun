import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hkun/bloc/bloc/auth_bloc.dart';
import 'package:hkun/bloc/market/market_bloc.dart';
import 'package:hkun/helpers/custom_clip_path.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/market_data_model.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/screens/home/home_screen.dart';
import 'package:hkun/screens/markets/coin_details_screen.dart';
import 'package:hkun/services/launcher_service.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _marketBloc = MarketBloc();
  List<MarketDataModel> _coinList = [];
  List<String> _newsImageUrls = [];
  NewsModel? _latestNews;
  MarketDataModel? _hkunInfo;

  final _refController = RefreshController();

  @override
  void initState() {
    _marketBloc.add(GetTopCoins());
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

        if (state is GetTopCoinsDone) {
          setState(() {
            _coinList = state.list;
            _newsImageUrls = state.imageUrls;
            _latestNews = state.latestNews;
            _hkunInfo = state.hkunInfo;
          });
        }

        if (state is ErrorMarket) {
          print('error: ${state.message}');
        }
      },
      builder: (context, state) {
        return SmartRefresher(
          onRefresh: () {
            _marketBloc.add(GetTopCoins());
            _refController.refreshCompleted();
          },
          controller: _refController,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBanner(),
                  InkWell(
                    onTap: () =>
                        BlocProvider.of<AuthBloc>(context).add(ShowNews()),
                    child: _buildPromoButton(),
                  ),
                  _buildTokens(),
                  _buildBuyHKUNBanner(),
                  _buildLearnMore(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildLearnMore() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 28.0),
          height: 135.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xFF1C1C1E),
          ),
          child: ClipPath(
            clipper: WaveShape(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: BoxDecoration(
                gradient: gradientColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => LauncherService.launchWebsite(),
          child: Container(
            margin: EdgeInsets.only(top: 28.0),
            height: 135.0,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 17.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Learn more from our website',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.7,
                      height: 1.12,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      FontAwesomeIcons.arrowCircleRight,
                      color: Color(0XFFFFFFFF),
                      size: 25.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildBuyHKUNBanner() {
    return InkWell(
      onTap: () => LauncherService.launchPancakeSwap(),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buy HKUN Tokens',
              style: TextStyle(
                color: Color(0xFF96969A),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => LauncherService.launchPancakeSwap(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color(0xFF1C1C1E),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pancake Swap',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              letterSpacing: -0.77,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Earn BUSD Rewards',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11,
                              letterSpacing: 0.25,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/pancakeswap_logo.png',
                                height: 21,
                                width: 21,
                              ),
                              Spacer(),
                              Icon(
                                FontAwesomeIcons.arrowCircleRight,
                                color: Color(0XFF757575),
                                size: 16.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: InkWell(
                    onTap: () => LauncherService.launchLBank(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color(0xFF1C1C1E),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LBank',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15,
                              letterSpacing: -0.77,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Tax Free Trading',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11,
                              letterSpacing: 0.25,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/lbank_logo.png',
                                height: 21,
                                width: 21,
                              ),
                              Spacer(),
                              Icon(
                                FontAwesomeIcons.arrowCircleRight,
                                color: Color(0XFF757575),
                                size: 16.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTokens() {
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      height: SizeConfig.safeBlockHorizontal * 19,
      width: double.infinity,
      child: Scrollbar(
        controller: ScrollController(),
        isAlwaysShown: true,
        thickness: 2.0,
        radius: Radius.circular(10.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Visibility(
              visible: _hkunInfo != null,
              child:
                  _hkunInfo != null ? _buildTokenItem(_hkunInfo!) : Container(),
            ),
            ..._coinList.map((coin) => _buildTokenItem(coin)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenItem(MarketDataModel coin) {
    return InkWell(
      onTap: () {
        if (coin.id != 'hakunamatata-new') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinDetailsScreen(coin: coin),
            ),
          );
        } else {
          BlocProvider.of<AuthBloc>(context).add(ShowHkun());
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 35.85),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${coin.symbol!.toUpperCase()}/USD',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.7,
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  '${coin.price_change_percentage_24h!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.price_change_percentage_24h! > 0
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                    fontSize: 10.7,
                  ),
                ),
              ],
            ),
            Text(
              '\$${coin.current_price!.toStringAsFixed(coin.id == 'hakunamatata-new' ? 6 : 2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            // Text(
            //   '\$$ath',
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontSize: 11.6,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Container _buildPromoButton() {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      height: 32,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFF1C1C1E),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.volumeUp,
                size: 14.0,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: _latestNews != null
                ? Marquee(
                    text: _latestNews!.content!,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    velocity: 25.0,
                    textScaleFactor: 1.2,
                  )
                : Container(),
          ),
          SizedBox(width: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.chevronRight,
                size: 14.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildBanner() {
    if (_newsImageUrls.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey.shade600,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enableInfiniteScroll: true,
          autoPlayInterval: Duration(seconds: 5),
          aspectRatio: 16 / 9,
          viewportFraction: 1,
        ),
        items: _newsImageUrls.map((url) => _buildBannerItem(url)).toList(),
      ),
    );
  }

  Widget _buildBannerItem(String url) {
    return InkWell(
      onTap: () {
        setState(() {
          BlocProvider.of<AuthBloc>(context).add(ShowNews());
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(8.0),
          gradient: gradientColor,
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
