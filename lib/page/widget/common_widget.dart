import 'package:flutter/material.dart';

Widget circleTextWidget(String text) {
  // print("Letter: $text");
  return Container(
    width: 18.0,
    height: 18.0,
    alignment: Alignment(0.0, 0.0),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal[400]),
    child: Text(
      text,
      style: TextStyle(fontSize: 10.0, color: Colors.white),
    ),
  );
}

Widget chapterWidget(String chapter) {
  return Container(
    height: 28.0,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.teal[400]),
    child: Text(
      "$chapter",
      style: TextStyle(color: Colors.white, fontSize: 12.0),
    ),
  );
}
