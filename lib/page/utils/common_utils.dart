import 'package:flutter_wanandroid/page/entity/entity.dart';
import 'package:flutter_wanandroid/page/utils/constant.dart';

class CommonUtils {
  static List<NavigationItem> buildNavigationItems() {
    var list = [];
    for (int i = 0; i < Constants.icons.length; i++) {
      list.add(NavigationItem(i, Constants.icons[i], Constants.titles[i]));
    }
    return list;
  }
}
