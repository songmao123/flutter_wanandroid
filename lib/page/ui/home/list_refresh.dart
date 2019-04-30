import 'dart:async';

import 'package:flutter/material.dart';

class ListRefresh extends StatefulWidget {
  final renderItem;
  final requestApi;
  final headerView;

  const ListRefresh([this.requestApi, this.renderItem, this.headerView])
      : super();

  @override
  State<StatefulWidget> createState() => _ListRefreshState();
}

class _ListRefreshState extends State<ListRefresh> {
  bool isLoading = false; // 是否正在请求数据中
  bool _hasMore = true; // 是否还有更多数据可加载
  int _pageIndex = 0; // 页面的索引
  int _pageSize = 0; // 页面的索引
  int _totalCount = 0;
  List items = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getMoreData();
    print("-------------------------------------------------------------------------------->ListRefresh initState");
    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  /*
  * 回弹效果
  * */
  backElasticEffect() {
//    double edge = 50.0;
//    double offsetFromBottom = _scrollController.position.maxScrollExtent -
//        _scrollController.position.pixels;
//    if (offsetFromBottom < edge) {
//      // 添加一个动画没有更多数据的时候 ListView 向下移动覆盖正在加载更多数据的标志
//      _scrollController.animateTo(
//          _scrollController.offset - (edge - offsetFromBottom),
//          duration: new Duration(milliseconds: 1000),
//          curve: Curves.easeOut);
//    }
  }

  /*
  * list探底，执行的具体事件
  * */
  Future _getMoreData() async {
    if (!isLoading && _hasMore) {
      // 如果上一次异步请求数据完成 同时有数据可以加载
      if (mounted) {
        setState(() => isLoading = true);
      }
      //if(_hasMore){ // 还有数据可以拉新
      List newEntries = await mokeHttpRequest();
      //if (newEntries.isEmpty) {
      _hasMore = (_pageSize <= 20);
      if (this.mounted) {
        setState(() {
          items.addAll(newEntries);
          isLoading = false;
        });
      }
      backElasticEffect();
    } else if (!isLoading && !_hasMore) {
      // 这样判断,减少以后的绘制
      _pageIndex = 0;
      backElasticEffect();
    }
  }

  /*
  * 伪装吐出新数据
  * */
  Future<List> mokeHttpRequest() async {
    if (widget.requestApi is Function) {
      final listObj = await widget.requestApi({'pageIndex': _pageIndex});
      _pageIndex = listObj['pageIndex'];
      _pageSize = listObj['page_size'];
      _totalCount  = listObj['total'];
      return listObj['list'];
    } else {
      return Future.delayed(Duration(seconds: 2), () {
        return [];
      });
    }
  }

  /*
  * 下拉加载的事件，清空之前list内容，取前X个
  * 其实就是列表重置
  * */
  Future<Null> _handleRefresh() async {
    _pageIndex = 0;
    List newEntries = await mokeHttpRequest();
    if (this.mounted) {
      setState(() {
        items.clear();
        items.addAll(newEntries);
        isLoading = false;
        _hasMore = true;
        return null;
      });
    }
  }

  /*
  * 加载中的提示
  * */
  Widget _buildLoadText() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Text("数据没有更多了！！！"),
      ),
    ));
  }

  /*
  * 上提加载loading的widget,如果数据到达极限，显示没有更多
  * */
  Widget _buildProgressIndicator() {
    if (_hasMore) {
      return new Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: isLoading ? 1.0 : 0.0,
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.teal)),
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              '稍等片刻更精彩...',
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      );
    } else {
      return _buildLoadText();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      color: Colors.teal,
      child: ListView.builder(
        itemCount: items.length + 2,
        /*physics: BouncingScrollPhysics(),*/
        itemBuilder: (context, i) {
          if (i == 0 /*&& index != items.length*/) {
            if (widget.headerView != null) {
              return widget.headerView(_totalCount);
            } else {
              return Container(height: 0);
            }
          } else if (i == items.length + 1) {
            return _buildProgressIndicator();
          } else {
            if (widget.renderItem is Function) {
              return widget.renderItem(i, items[i - 1]);
            }
          }
        },
        controller: _scrollController,
      ),
      onRefresh: _handleRefresh,
    );
  }
}
