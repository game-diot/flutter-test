import 'dio_api_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

static String baseUrl = 'https://us12-h5.yanshi.lol/api/app-api/pay/symbol/search?pageNo=1&pageSize=10&plate=&type=1&priceSort=0&upDownRangSort=0&fuzzy=';

class GetTestData{
    static GetAllTestData()async{
        return DioHttpManager.getInstance()
        .get(DioApiUrl.baseUrl);
    }
}