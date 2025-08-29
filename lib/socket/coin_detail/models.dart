// models/new_account_statistics.dart
class NewAccountStatistics {
  final Overview overview;
  final Contract contract;
  final Coin coin;

  NewAccountStatistics({
    required this.overview,
    required this.contract,
    required this.coin,
  });

  factory NewAccountStatistics.fromJson(Map<String, dynamic> json) {
    return NewAccountStatistics(
      overview: Overview.fromJson(json['overview']),
      contract: Contract.fromJson(json['contract']),
      coin: Coin.fromJson(json['coin']),
    );
  }
}

class Overview {
  final double ta;
  final double tpv;
  final double tfpl;
  final double taa;
  final double tfa;
  final double? tw;
  final double? tr;
  final int hotpal;

  Overview({
    required this.ta,
    required this.tpv,
    required this.tfpl,
    required this.taa,
    required this.tfa,
    this.tw,
    this.tr,
    required this.hotpal,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      ta: (json['ta'] ?? 0).toDouble(),
      tpv: (json['tpv'] ?? 0).toDouble(),
      tfpl: (json['tfpl'] ?? 0).toDouble(),
      taa: (json['taa'] ?? 0).toDouble(),
      tfa: (json['tfa'] ?? 0).toDouble(),
      tw: json['tw']?.toDouble(),
      tr: json['tr']?.toDouble(),
      hotpal: json['hotpal'] ?? 0,
    );
  }
}

class Contract {
  final double ta;
  final double tpv;
  final double taa;
  final double tfa;
  final double tfpl;
  final double tdpl;
  final int? hotpal;
  final List<PLItem> plList;

  Contract({
    required this.ta,
    required this.tpv,
    required this.taa,
    required this.tfa,
    required this.tfpl,
    required this.tdpl,
    this.hotpal,
    required this.plList,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      ta: (json['ta'] ?? 0).toDouble(),
      tpv: (json['tpv'] ?? 0).toDouble(),
      taa: (json['taa'] ?? 0).toDouble(),
      tfa: (json['tfa'] ?? 0).toDouble(),
      tfpl: (json['tfpl'] ?? 0).toDouble(),
      tdpl: (json['tdpl'] ?? 0).toDouble(),
      hotpal: json['hotpal'],
      plList: (json['plList'] as List<dynamic>? ?? [])
          .map((e) => PLItem.fromJson(e))
          .toList(),
    );
  }
}

class PLItem {
  final String subscribeSymbol;
  final double plAmount;
  final double plRatio;
  final double lever;
  final double endPrice;
  final int direction;

  PLItem({
    required this.subscribeSymbol,
    required this.plAmount,
    required this.plRatio,
    required this.lever,
    required this.endPrice,
    required this.direction,
  });

  factory PLItem.fromJson(Map<String, dynamic> json) {
    return PLItem(
      subscribeSymbol: json['subscribeSymbol'] ?? '',
      plAmount: (json['plAmount'] ?? 0).toDouble(),
      plRatio: (json['plRatio'] ?? 0).toDouble(),
      lever: (json['lever'] ?? 0).toDouble(),
      endPrice: (json['endPrice'] ?? 0).toDouble(),
      direction: json['direction'] ?? 0,
    );
  }
}

class Coin {
  final double ta;
  final double taa;
  final double tfa;
  final List<WalletItem> walletList;

  Coin({
    required this.ta,
    required this.taa,
    required this.tfa,
    required this.walletList,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      ta: (json['ta'] ?? 0).toDouble(),
      taa: (json['taa'] ?? 0).toDouble(),
      tfa: (json['tfa'] ?? 0).toDouble(),
      walletList: (json['walletList'] as List<dynamic>? ?? [])
          .map((e) => WalletItem.fromJson(e))
          .toList(),
    );
  }
}

class WalletItem {
  final String name;
  final double ab;

  WalletItem({
    required this.name,
    required this.ab,
  });

  factory WalletItem.fromJson(Map<String, dynamic> json) {
    return WalletItem(
      name: json['name'] ?? '',
      ab: (json['ab'] ?? 0).toDouble(),
    );
  }
}
