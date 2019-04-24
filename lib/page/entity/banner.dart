import 'dart:convert';

import 'package:flutter_wanandroid/page/http/http_utils.dart';
import 'package:flutter_wanandroid/page/utils/url_utils.dart';
import 'package:http/http.dart' as http;

class BannerData {
  int errorCode;
  String errorMsg;
  List<BannerItem> data;

  BannerData({this.errorCode, this.data, this.errorMsg});

  factory BannerData.fromJson(Map<String, dynamic> jsonStr) {
    var list = jsonStr['data'] as List;
    print('List type: ${list.runtimeType}');
    List<BannerItem> itemList =
        list.map((i) => BannerItem.fromJson(i)).toList();

    return BannerData(
        errorCode: jsonStr['errorCode'],
        errorMsg: jsonStr['errorMsg'],
        data: itemList);
  }
}

class BannerItem {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  BannerItem(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      desc: json['desc'],
      id: json['id'],
      imagePath: json['imagePath'],
      isVisible: json['isVisible'],
      order: json['order'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
    );
  }
}

Future<BannerData> fetchBanner() async {
  /*final response = await http.get('http://www.wanandroid.com/banner/json');
  if (response.statusCode == 200) {
    return BannerData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fail to load banner data.');
  }*/
  var response = HttpUtils.get(UrlConstant.BANNER_URL).then((value) {
    var bannerData = BannerData.fromJson(value);
    return bannerData;
  });
  return response;
}
