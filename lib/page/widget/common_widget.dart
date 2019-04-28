import 'package:flutter/material.dart';

Widget circleTextWidget(String text) {
  // print("Letter: $text");
  return CircleAvatar(
    radius: 8.0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.teal,
    child: Text(
      text,
      style: TextStyle(
          color: Colors.white, fontFamily: "Montserrat-Bold", fontSize: 10.0),
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
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
