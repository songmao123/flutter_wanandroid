import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/entity/banner.dart';

const TOTAL_PAGE_COUNT = 100000;

class BannerWidget extends StatefulWidget {
  final List<BannerItem> bannerList;

  BannerWidget({
    Key key,
    @required this.bannerList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BannerWidgetState();
}

class BannerWidgetState extends State<BannerWidget>
    with WidgetsBindingObserver {
  Timer _timer;
  double screenWidth;
  int _currentIndex = 0;
  double bannerHeight = 180.0;
  PageController _pageController;

  @override
  void initState() {
    double current = TOTAL_PAGE_COUNT / 2 -
        (TOTAL_PAGE_COUNT / 2) % widget.bannerList.length;
    _pageController = PageController(
      initialPage: current.toInt(),
      viewportFraction: 1.0,
    );
    startLoop();

    _getImage(widget.bannerList[0].imagePath).then((value) {
      double height = (screenWidth - 16.0) * value.height / value.width + 16.0;
      print('Image height: $height, Screen width: $screenWidth');
      setState(() {
        bannerHeight = height;
      });
    });

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void startLoop() {
    stopLoop();
    _timer = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      // print('Timer is comming...');
      _pageController.animateToPage(
        _pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  void stopLoop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startLoop();
    } else if (state == AppLifecycleState.paused) {
      stopLoop();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<ui.Image> _getImage(String url) async {
    Completer<ui.Image> completer = Completer();
    NetworkImage(url).resolve(ImageConfiguration()).addListener((imageInfo, _) {
      completer.complete(imageInfo.image);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: bannerHeight,
      child: Stack(
        children: <Widget>[
          viewPagerWidget(),
          indicatorWidget(),
        ],
      ),
    );
  }

  Widget viewPagerWidget() {
    return PageView.builder(
      itemCount: TOTAL_PAGE_COUNT,
      controller: _pageController,
      onPageChanged: _pageChanged,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  widget.bannerList[index % widget.bannerList.length].imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ));
      },
    );
  }

  Widget indicatorWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _dotList(),
        ),
      ),
    );
  }

  List<Widget> _dotList() {
    List<Widget> dotList = [];
    for (var i = 0; i < widget.bannerList.length; i++) {
      dotList.add(Container(
        margin: EdgeInsets.all(3.0),
        width: 6.0,
        height: 6.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i == _currentIndex ? Colors.teal : Colors.grey[300],
        ),
      ));
    }
    return dotList;
  }

  void _pageChanged(int value) {
    _currentIndex = value % widget.bannerList.length;
    setState(() {});
  }

  @override
  void dispose() {
    stopLoop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
