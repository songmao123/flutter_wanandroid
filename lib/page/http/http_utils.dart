import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/page/utils/url_utils.dart';

var options =
    BaseOptions(baseUrl: UrlConstant.BASE_URL, responseType: ResponseType.json);
var dio = Dio(options)..interceptors.add(LogInterceptor(responseBody: false));

class HttpUtils {
  static Future get(String url, {Map<String, dynamic> params}) async {
    var response = await dio.get(url, queryParameters: params);
    var result = response.data;
    print("Response: $result");
    return result;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    var response = await dio.post(url, queryParameters: params);
    var result = response.data;
    print("Response: $result");
    return result;
  }
}
