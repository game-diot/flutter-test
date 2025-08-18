
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

String baseUrl = 'https://us12-h5.yanshi.lol/api/app-api/pay/symbol/search?pageNo=1&pageSize=10&plate=&type=1&priceSort=0&upDownRangSort=0&fuzzy=';
class GetTestData {
  static Future<List<SymbolItem>?> getAllTestData() async {
    try {
      final response = await Dio().get(baseUrl);
      if (response.statusCode == 200) {
        var dataList = response.data['data']['list'] as List<dynamic>?;
        if (dataList != null) {
          return dataList.map((e) => SymbolItem.fromJson(e)).toList();
        }
      } else {
        print('请求失败：${response.statusCode}');
      }
    } catch (e) {
      print('请求异常: $e');
    }
    return null;
  }
}


class SymbolItem {
  final String symbolId;
  final String alias;
  final String symbol;
  final String baseSymbol;
  final String exchangeSymbol;
  final String icon1;
  final String icon2;
  final double volume24h;
  final List<double> miniKlinePriceList;
  final double commission;
  final int priceAccuracy;
  final int transactionAccuracy;

  SymbolItem({
    required this.symbolId,
    required this.alias,
    required this.symbol,
    required this.baseSymbol,
    required this.exchangeSymbol,
    required this.icon1,
    required this.icon2,
    required this.volume24h,
    required this.miniKlinePriceList,
    required this.commission,
    required this.priceAccuracy,
    required this.transactionAccuracy,
  });

  factory SymbolItem.fromJson(Map<String, dynamic> json) {
    return SymbolItem(
      symbolId: json['symbolId'] ?? '',
      alias: json['alias'] ?? '',
      symbol: json['symbol'] ?? '',
      baseSymbol: json['baseSymbol'] ?? '',
      exchangeSymbol: json['exchangeSymbol'] ?? '',
      icon1: json['icon1'] ?? '',
      icon2: json['icon2'] ?? '',
      volume24h: (json['volume24h'] ?? 0).toDouble(),
      miniKlinePriceList: (json['miniKlinePriceList'] as List<dynamic>?)
?.map((dynamic e) => (e as num).toDouble())
              .toList() ??
          [],
      commission: (json['commission'] ?? 0).toDouble(),
      priceAccuracy: json['priceAccuracy'] ?? 0,
      transactionAccuracy: json['transactionAccuracy'] ?? 0,
    );
  }
}

void fetchAndUseData() async {
  List<SymbolItem>? response = await GetTestData.getAllTestData();
  if (response != null) {
    print('${response[0].symbolId} ${response[0].alias} ${response[0].symbol} ${response[0].baseSymbol} ${response[0].exchangeSymbol} ${response[0].icon1} ${response[0].icon2} ${response[0].volume24h} ${response[0].miniKlinePriceList} ${response[0].commission} ${response[0].priceAccuracy} ${response[0].transactionAccuracy}');
  }
}
