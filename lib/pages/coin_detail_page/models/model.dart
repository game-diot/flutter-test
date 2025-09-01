import 'dart:convert';

/// 根据实际 API 响应重新设计的 CoinDetail 模型
class CoinDetail {
  final int startTime;
  final String symbolId;
  final String coinId;
  final double firstHand;
  final double defaultNum;
  final double minNum;
  final int type;
  final double spread;
  final int priceAccuracy;
  final int transactionAccuracy;
  final String icon2;
  final int earnestMoneyType;
  final double earnestMoney;
  final String icon1;
  final double commission;
  final double maxNum;
  final String alias;
  final int sort;
  final int commissionType;
  final int status;
  final int tradeStatus;
  final int vip;
  final String commissionConfig; // JSON 字符串
  final List<CommissionLevel> commissionLevels; // 解析后的佣金等级

  CoinDetail({
    required this.startTime,
    required this.symbolId,
    required this.coinId,
    required this.firstHand,
    required this.defaultNum,
    required this.minNum,
    required this.type,
    required this.spread,
    required this.priceAccuracy,
    required this.transactionAccuracy,
    required this.icon2,
    required this.earnestMoneyType,
    required this.earnestMoney,
    required this.icon1,
    required this.commission,
    required this.maxNum,
    required this.alias,
    required this.sort,
    required this.commissionType,
    required this.status,
    required this.tradeStatus,
    required this.vip,
    required this.commissionConfig,
    required this.commissionLevels,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    // 解析 commissionConfig 字符串为 CommissionLevel 列表
    List<CommissionLevel> parseCommissionLevels(String? configString) {
      if (configString == null || configString.isEmpty) return [];
      
      try {
        // 如果字符串被截断，尝试修复
        String fixedString = configString;
        if (!configString.endsWith(']')) {
          fixedString = configString + '}]';
        }
        
        final List<dynamic> configList = jsonDecode(fixedString);
        return configList
            .map((item) => CommissionLevel.fromJson(item))
            .toList();
      } catch (e) {
        print("⚠️ [Commission Parse] Failed to parse commission config: $e");
        return [];
      }
    }

    final commissionConfigStr = json['commissionConfig']?.toString() ?? '';
    
    return CoinDetail(
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
      symbolId: json['symbolId']?.toString() ?? '',
      coinId: json['coinId']?.toString() ?? '',
      firstHand: (json['firstHand'] as num?)?.toDouble() ?? 0.0,
      defaultNum: (json['defaultNum'] as num?)?.toDouble() ?? 0.0,
      minNum: (json['minNum'] as num?)?.toDouble() ?? 0.0,
      type: (json['type'] as num?)?.toInt() ?? 0,
      spread: (json['spread'] as num?)?.toDouble() ?? 0.0,
      priceAccuracy: (json['priceAccuracy'] as num?)?.toInt() ?? 0,
      transactionAccuracy: (json['transactionAccuracy'] as num?)?.toInt() ?? 0,
      icon2: json['icon2']?.toString() ?? '',
      earnestMoneyType: (json['earnestMoneyType'] as num?)?.toInt() ?? 0,
      earnestMoney: (json['earnestMoney'] as num?)?.toDouble() ?? 0.0,
      icon1: json['icon1']?.toString() ?? '',
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      maxNum: (json['maxNum'] as num?)?.toDouble() ?? 0.0,
      alias: json['alias']?.toString() ?? '',
      sort: (json['sort'] as num?)?.toInt() ?? 0,
      commissionType: (json['commissionType'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      tradeStatus: (json['tradeStatus'] as num?)?.toInt() ?? 0,
      vip: (json['vip'] as num?)?.toInt() ?? 0,
      commissionConfig: commissionConfigStr,
      commissionLevels: parseCommissionLevels(commissionConfigStr),
    );
  }

  // 为了兼容旧代码，提供一些便利方法
  String get symbol => alias; // 使用 alias 作为 symbol
  String get name => alias; // 临时使用 alias 作为 name
  String get baseAlias => _extractBaseCurrency();
  String get coinAlias => _extractCoinCurrency();
  double get volume24h => 0.0; // API 中没有返回，设为默认值

  // 从 alias 中提取基础货币（如从 BNBARKAIUSDT 提取）
  String _extractBaseCurrency() {
    if (alias.endsWith('USDT')) {
      return alias.substring(0, alias.length - 4);
    }
    return alias;
  }

  // 提取计价货币
  String _extractCoinCurrency() {
    if (alias.endsWith('USDT')) {
      return 'USDT';
    }
    return 'USDT'; // 默认
  }

  // 获取可用杠杆列表
  List<int> get availableLeverages {
    return commissionLevels.map((level) => level.lever).toList();
  }

  @override
  String toString() {
    return 'CoinDetail(alias: $alias, symbolId: $symbolId, priceAccuracy: $priceAccuracy)';
  }
}

/// 佣金等级模型
class CommissionLevel {
  final int lever;
  final double commission;
  final bool isVip;
  final int useLimit;
  final String field;

  CommissionLevel({
    required this.lever,
    required this.commission,
    required this.isVip,
    required this.useLimit,
    required this.field,
  });

  factory CommissionLevel.fromJson(Map<String, dynamic> json) {
    return CommissionLevel(
      lever: int.tryParse(json['lever']?.toString() ?? '0') ?? 0,
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      isVip: json['isVip'] == true,
      useLimit: (json['useLimit'] as num?)?.toInt() ?? 0,
      field: json['field']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'CommissionLevel(lever: ${lever}x, commission: $commission)';
  }
}