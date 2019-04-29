import 'package:flutter_wanandroid/page/http/http_utils.dart';
import 'package:flutter_wanandroid/page/utils/url_utils.dart';

class HotSearchBean {
  List<HotSearchData> data;
  int errorCode;
  String errorMsg;

  HotSearchBean({this.data, this.errorCode, this.errorMsg});

  HotSearchBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HotSearchData>();
      json['data'].forEach((v) {
        data.add(new HotSearchData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class HotSearchData {
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotSearchData({this.id, this.link, this.name, this.order, this.visible});

  HotSearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['order'] = this.order;
    data['visible'] = this.visible;
    return data;
  }
}

Future<HotSearchBean> getHotSearchData() {
  var response = HttpUtils.get(UrlConstant.HOT_SEARCH_URL).then((value) {
    var searchBean = HotSearchBean.fromJson(value);
    return searchBean;
  });
  return response;
}