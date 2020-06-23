import 'package:flutter/material.dart';

class ThemeConstants {
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xffffbd00); //Color(0xffffe66d);
  static Color lightAccent = Color.fromRGBO(69, 123, 157, 1);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;

  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightAccent,
      highlightElevation: 5,
    ),
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    brightness: Brightness.light,
    primaryIconTheme: IconThemeData(color: lightAccent),
    iconTheme: IconThemeData(color: lightAccent),
    appBarTheme: AppBarTheme(
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.15,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 28.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.20,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkAccent,
      highlightElevation: 5,
    ),
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    cursorColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    brightness: Brightness.dark,
    primaryIconTheme: IconThemeData(color: lightAccent),
    iconTheme: IconThemeData(color: lightAccent),
    appBarTheme: AppBarTheme(
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.15,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontSize: 28.0,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.20,
      ),
    ),
  );
}
