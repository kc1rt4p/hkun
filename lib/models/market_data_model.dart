class MarketDataModel {
  String? id;
  String? symbol;
  String? image;
  String? name;

  double? current_price;
  int? market_cap;
  int? market_cap_rank;
  double? market_cap_change_24h;
  int? fully_diluted_valuation;
  int? total_volume;
  double? high_24h;
  double? low_24h;
  double? price_change_24h;
  double? price_change_percentage_24h;
  double? circulating_supply;
  double? total_supply;
  double? max_supply;
  double? ath;
  double? ath_change_percentage;
  double? atl;
  Map<String, dynamic>? roi;
  double? atl_change_percentage;

  DateTime? ath_date;
  DateTime? atl_date;
  DateTime? last_updated;

  List<double>? sparkline_in_7d;

  MarketDataModel({
    this.id,
    this.symbol,
    this.image,
    this.name,
    this.current_price,
    this.market_cap,
    this.market_cap_rank,
    this.market_cap_change_24h,
    this.fully_diluted_valuation,
    this.total_volume,
    this.high_24h,
    this.low_24h,
    this.price_change_24h,
    this.price_change_percentage_24h,
    this.circulating_supply,
    this.total_supply,
    this.max_supply,
    this.ath,
    this.ath_change_percentage,
    this.atl,
    this.roi,
    this.atl_change_percentage,
    this.ath_date,
    this.atl_date,
    this.last_updated,
    this.sparkline_in_7d,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'symbol': this.symbol,
      'image': this.image,
      'name': this.name,
      'current_price': this.current_price,
      'market_cap': this.market_cap,
      'market_cap_rank': this.market_cap_rank,
      'market_cap_change_24h': this.market_cap_change_24h,
      'fully_diluted_valuation': this.fully_diluted_valuation,
      'total_volume': this.total_volume,
      'high_24h': this.high_24h,
      'low_24h': this.low_24h,
      'price_change_24h': this.price_change_24h,
      'price_change_percentage_24h': this.price_change_percentage_24h,
      'circulating_supply': this.circulating_supply,
      'total_supply': this.total_supply,
      'max_supply': this.max_supply,
      'ath': this.ath,
      'ath_change_percentage': this.ath_change_percentage,
      'atl': this.atl,
      'roi': this.roi,
      'atl_change_percentage': this.atl_change_percentage,
      'ath_date': this.ath_date,
      'atl_date': this.atl_date,
      'last_updated': this.last_updated,
      'sparkline_in_7d': this.sparkline_in_7d,
    };
  }

  factory MarketDataModel.fromJson2(Map<String, dynamic> json) {
    final Map<String, dynamic> marketData = json['market_data'];
    return MarketDataModel(
      id: json['id'] as String?,
      symbol: json['symbol'] as String?,
      image: (json['image'] as Map<String, dynamic>)['large'] as String?,
      name: json['name'] as String?,
      market_cap: (((json['market_data'] as Map<String, dynamic>)['market_cap']
              as Map<String, dynamic>)['usd'] as double)
          .round(),
      current_price:
          ((json['market_data'] as Map<String, dynamic>)['current_price']
              as Map<String, dynamic>)['usd'] as double?,
      market_cap_change_24h: (json['market_data']
          as Map<String, dynamic>)['market_cap_change_24h'] as double?,
      total_volume:
          (((json['market_data'] as Map<String, dynamic>)['total_volume']
                  as Map<String, dynamic>)['usd'] as num)
              .roundToDouble()
              .round(),
      high_24h: ((json['market_data'] as Map<String, dynamic>)['high_24h']
          as Map<String, dynamic>)['usd'] as double?,
      low_24h: ((json['market_data'] as Map<String, dynamic>)['low_24h']
          as Map<String, dynamic>)['usd'] as double?,
      price_change_24h: (json['market_data']
          as Map<String, dynamic>)['price_change_24h'] as double?,
      price_change_percentage_24h: (json['market_data']
          as Map<String, dynamic>)['price_change_percentage_24h'] as double?,
      circulating_supply: (json['market_data']
          as Map<String, dynamic>)['circulating_supply'] as double?,
      total_supply: (json['market_data']
          as Map<String, dynamic>)['total_supply'] as double?,
      max_supply: (json['market_data'] as Map<String, dynamic>)['max_supply']
          as double?,
      ath: ((json['market_data'] as Map<String, dynamic>)['ath']
          as Map<String, dynamic>)['usd'] as double?,
      ath_change_percentage: ((json['market_data']
              as Map<String, dynamic>)['ath_change_percentage']
          as Map<String, dynamic>)['usd'] as double?,
      atl: ((json['market_data'] as Map<String, dynamic>)['atl']
          as Map<String, dynamic>)['usd'] as double?,
      atl_change_percentage: ((json['market_data']
              as Map<String, dynamic>)['atl_change_percentage']
          as Map<String, dynamic>)['usd'] as double?,
      last_updated: DateTime.parse(((json['market_data']
          as Map<String, dynamic>)['last_updated'] as String)),
      sparkline_in_7d:
          (json['market_data'] as Map<String, dynamic>)['sparkline_7d'] != null
              ? (((json['market_data'] as Map<String, dynamic>)['sparkline_7d']
                      as Map<String, dynamic>)['price'] as List<dynamic>)
                  .cast<double>()
              : [],
    );
  }

  factory MarketDataModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['sparkline_in_7d'] != null) {
        print(json['sparkline_in_7d']['price']);
      }
      return MarketDataModel(
        id: json['id'] as String?,
        symbol: json['symbol'] as String?,
        image: json['image'] as String?,
        name: json['name'] as String?,
        current_price: json['current_price'] + 0.00,
        market_cap: json['market_cap'] as int?,
        market_cap_rank: json['market_cap_rank'] as int?,
        market_cap_change_24h: json['market_cap_change_24h'] + 0.00,
        fully_diluted_valuation: json['fully_diluted_valuation'] as int?,
        total_volume: json['total_volume'] as int?,
        high_24h: (json['high_24h'] + 0.00),
        low_24h: (json['low_24h'] + 0.00),
        price_change_24h: json['price_change_24h'] as double?,
        price_change_percentage_24h:
            json['price_change_percentage_24h'] as double?,
        circulating_supply: json['circulating_supply'] as double?,
        total_supply: json['total_supply'] as double?,
        max_supply: json['max_supply'] as double?,
        ath: (json['ath'] + 0.00),
        ath_change_percentage: json['ath_change_percentage'] as double?,
        atl: json['atl'] as double?,
        roi: json['roi'] as Map<String, dynamic>?,
        atl_change_percentage: json['atl_change_percentage'] as double?,
        ath_date: DateTime.parse(json['ath_date'] as String),
        atl_date: DateTime.parse(json['atl_date'] as String),
        last_updated: DateTime.parse(json['last_updated'] as String),
        sparkline_in_7d: json['sparkline_in_7d'] != null
            ? (json['sparkline_in_7d']['price'] as List<dynamic>).cast<double>()
            : [],
      );
    } catch (e) {
      print(e.toString());
      return MarketDataModel();
    }
  }
}
