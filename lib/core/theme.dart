import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.amber,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
  );
}
