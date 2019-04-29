import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wanandroid/page/entity/entity.dart';
import 'package:flutter_wanandroid/page/entity/hot_search.dart';
import 'package:flutter_wanandroid/page/http/http_utils.dart';
import 'package:flutter_wanandroid/page/ui/home/list_refresh.dart';
import 'package:flutter_wanandroid/page/utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryTextController = TextEditingController();

  List<HotSearchData> hotSearchList;

  @override
  void initState() {
    super.initState();
    _queryTextController.addListener(_onQueryChanged);

    _loadHotSearchData();
  }

  @override
  void dispose() {
    super.dispose();
    _queryTextController.removeListener(_onQueryChanged);
  }

  void _loadHotSearchData() {
    getHotSearchData().then((searchBean) {
      if (searchBean.errorCode == 0 && searchBean.data.isNotEmpty) {
        setState(() {
          hotSearchList = searchBean.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _queryTextController.text = "";
              })
        ],
        title: TextField(
          controller: _queryTextController,
          textInputAction: TextInputAction.search,
          onSubmitted: (String _) {},
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: "Montserrat-Medium",
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              hintStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.white54,
                fontFamily: "Montserrat-Medium",
              )),
        ),
      ),
      body: CommonUtils.isStringEmpty(_queryTextController.text)
          ? _buildSuggestions()
          : _buildSearchContent(),
    );
  }

  void _onQueryChanged() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
    print(
        "Text changed: -------------------------------------------> ${_queryTextController.text}");
  }

  Widget _buildSuggestions() {
    if (hotSearchList == null || hotSearchList.isEmpty) {
      return Container();
    }

    var suggestionWidgets = hotSearchList
        .map((data) => Container(
              child: InputChip(
                label: Text(
                  data.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-Medium",
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Colors.teal,
                disabledColor: Colors.teal,
                elevation: 2.0,
                onPressed: () {
                  _queryTextController.text = data.name;
                  Fluttertoast.showToast(msg: data.name);
                },
              ),
              margin: EdgeInsets.only(right: 16.0),
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hot Search",
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xff666666),
              fontFamily: "Montserrat-Medium",
            ),
          ),
          Wrap(
            children: suggestionWidgets,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    return Column(
      children: <Widget>[
        Expanded(child: ListRefresh(getIndexListData, buildCard, headerView))
      ],
    );
  }

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;
    var responseList = [];
    var resultCount = 0;

    String url = "/article/query/$pageIndex/json";
    try {
      var response =
          await HttpUtils.post(url, {"k": _queryTextController.text});
      responseList = response['data']['datas'];
      resultCount = response['data']['total'];
    } catch (e) {}
    pageIndex += 1;
    List resultList = new List();
    for (int i = 0; i < responseList.length; i++) {
      ArticleData cellData = ArticleData.fromJson(responseList[i]);
      resultList.add(cellData);
    }
    Map<String, dynamic> result = {
      "list": resultList,
      'page_size': resultList.length,
      'pageIndex': pageIndex,
      'total': resultCount,
    };
    return result;
  }

  Widget headerView(int totalCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "RESULT",
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 14.0,
                fontFamily: "Montserrat-Medium"),
          ),
          Text(
            "$totalCount",
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 14.0,
                fontFamily: "Montserrat-Medium"),
          ),
        ],
      ),
    );
  }

  Widget buildCard(int index, ArticleData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 16.0, bottom: 16.0, right: 60.0),
                  child: Column(
                    children: <Widget>[
                      Html(
                          data: "${item.title.trim()}",
                          defaultTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: "Montserrat-Bold",
                              fontWeight: FontWeight.bold),
                          customRender: (node, children) {
                            if (node is dom.Element) {
                              switch (node.localName) {
                                case "em":
                                  return Text(
                                    node.text,
                                    style: TextStyle(color: Colors.teal),
                                  );
                              }
                            }
                          }),
                      SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.teal,
                            size: 18.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            item.author,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Montserrat-medium"),
                          ),
                          SizedBox(width: 16.0),
                          Icon(
                            Icons.access_time,
                            color: Colors.teal,
                            size: 18.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            item.niceDate,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Montserrat-medium"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 16.0,
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
                )
              ],
            ),
            Container(
              height: 0.8,
              margin: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
            )
          ],
        ),
      ),
    );
  }
}
