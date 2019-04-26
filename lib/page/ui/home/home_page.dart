import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/entity/banner.dart';
import 'package:flutter_wanandroid/page/entity/entity.dart';
import 'package:flutter_wanandroid/page/http/http_utils.dart';
import 'package:flutter_wanandroid/page/ui/home/banner_widget.dart';
import 'package:flutter_wanandroid/page/ui/home/list_refresh.dart';
import 'package:flutter_wanandroid/page/utils/common_utils.dart';
import 'package:flutter_wanandroid/page/widget/common_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: ListRefresh(getIndexListData, buildCard, headerView()))
      ],
    );
  }

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;
    var responseList = [];
    var pageTotal = 0;

    String url = "/article/list/$pageIndex/json";
    try {
      var response = await HttpUtils.get(url);
      responseList = response['data']['datas'];
      pageTotal = response['d']['total'];
      if (!(pageTotal is int) || pageTotal <= 0) {
        pageTotal = 0;
      }
    } catch (e) {}
    pageIndex += 1;
    List resultList = new List();
    for (int i = 0; i < responseList.length; i++) {
      ArticleData cellData = ArticleData.fromJson(responseList[i]);
      resultList.add(cellData);
    }
    Map<String, dynamic> result = {
      "list": resultList,
      'total': resultList.length,
      'pageIndex': pageIndex
    };
    return result;
  }

  Widget buildCard(int index, ArticleData item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFd0d0d0),
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: Offset(1.0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            circleTextWidget(CommonUtils.findFirstLetter(
                                item.author.trim())),
                            SizedBox(width: 8.0),
                            Text("${item.author}",
                                style: TextStyle(fontSize: 14.0))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                size: 18.0,
                                color: Colors.teal[400],
                              ),
                              SizedBox(width: 3.0),
                              Text(
                                item.niceDate,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text("${item.title.trim()}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      children: <Widget>[
                        chapterWidget("${item.superChapterName}"),
                        SizedBox(width: 16.0),
                        chapterWidget("${item.chapterName}"),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
                Positioned(
                  right: 8.0,
                  bottom: 8.0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Icon(Icons.star_border, color: Colors.teal[400])),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerView() {
    return FutureBuilder<BannerData>(
      future: fetchBanner(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BannerWidget(bannerList: snapshot.data.data);
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200.0,
            child: Stack(
              children: <Widget>[
                Text('${snapshot.error}'),
              ],
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            height: 180.0,
            child: Stack(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
