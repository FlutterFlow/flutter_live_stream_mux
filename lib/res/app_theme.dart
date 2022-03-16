import 'package:flutter/material.dart';

class AppTheme {
  static final primary = ThemeData(
    primarySwatch: Colors.indigo,
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
