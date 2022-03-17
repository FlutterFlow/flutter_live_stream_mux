import 'package:flutter/material.dart';

class AppTheme {
  static final primary = ThemeData(
    primarySwatch: Colors.pink,
    fontFamily: 'GoogleSans',
    backgroundColor: Colors.indigo,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w500,
        color: Colors.indigoAccent,
      ),
      headline2: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: Colors.indigoAccent,
      ),
    ),
  );
}

class CustomColors {
  static const Color muxPink = Color(0xFFff1f78);
  static const Color muxPinkLight = Color(0xFFff709a);
  static const Color muxPinkVeryLight = Color(0xFFfef6f7);
  static const Color muxOrange = Color(0xFFff4b03);
  static const Color muxOrangeLight = Color(0xFFff7d6e);
  static const Color muxGray = Color(0xFF383838);
  static const Color muxGrayLight = Color(0xFFf9f9f9);
}
