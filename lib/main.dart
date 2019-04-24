import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/page/ui/home/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final preferences = await SharedPreferences.getInstance();
  runApp(WanApp(preferences));
}

class WanApp extends StatelessWidget {
  final SharedPreferences preferences;

  WanApp(this.preferences);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanAndroid',
      theme: ThemeData(
        primaryColor: Colors.teal,
        backgroundColor: Colors.grey[200],
      ),
      home: Scaffold(
        body: MainPage(),
      ),
    );
  }
}
