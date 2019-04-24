import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/ui/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int COUNTDOWN_TIME = 3;
const SPLASH_ARRAY = <String>[
  'assets/images/splash01.jpg',
  'assets/images/splash02.jpg',
  'assets/images/splash03.jpg',
  'assets/images/splash04.jpg',
  'assets/images/splash05.jpg'
];

class SplashPage extends StatefulWidget {
  final _splashIndex = Random().nextInt(5);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState(_splashIndex);
  }
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;
  int _countDownValue = COUNTDOWN_TIME;

  _SplashPageState(int splashIndex);

  @override
  void initState() {
    _saveBgImageIndex();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Timer tick: ${timer.tick}');
      var value = COUNTDOWN_TIME - timer.tick;
      if (value >= 0) {
        setState(() {
          _countDownValue = value;
        });
      } else {
        _startLoginPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _content(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(SPLASH_ARRAY[widget._splashIndex]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(top: 50.0, right: 30.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            onTap: _startLoginPage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                child: Text(
                  '$_countDownValue s',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopCountTimer();
    super.dispose();
  }

  void _stopCountTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startLoginPage() {
    _stopCountTimer();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void _saveBgImageIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('background_image_index', widget._splashIndex);
  }
}
