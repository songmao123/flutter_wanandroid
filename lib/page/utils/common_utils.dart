import 'package:flutter_wanandroid/page/entity/entity.dart';
import 'package:flutter_wanandroid/page/utils/constant.dart';
import 'package:lpinyin/lpinyin.dart';

class CommonUtils {
  static List<NavigationItem> buildNavigationItems() {
    var list = [];
    for (int i = 0; i < Constants.icons.length; i++) {
      list.add(NavigationItem(i, Constants.icons[i], Constants.titles[i]));
    }
    return list;
  }

  static String findFirstLetter(String text) {
    if (text == null || text.length == 0) return "";
    text = PinyinHelper.getPinyin(text);
    for (int i = 0; i < text.length; i++) {
      var char = text[i];
      if (char != null && char != "" && char != " ") {
        return char.toUpperCase();
      }
    }
    return "";
  }
}
