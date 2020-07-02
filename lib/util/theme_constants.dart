import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeConstants with ChangeNotifier {
  SharedPreferences _prefs;
  //Default Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xffffbd00);
  static Color lightAccent =
      Color(0xff7678ed); //Color.fromRGBO(69, 123, 157, 1);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;

  //for changing the accent
  Color _accentColor;
  Color _navbarAppvarColor;
  Color get accentColor => _accentColor;
  Color get navbarAppvarColor => _navbarAppvarColor;
  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;
  bool _isDarkModeON = false;
  bool get isDarkModeON => _isDarkModeON;

  ThemeConstants() {
    initThemeConstant();
  }
  initThemeConstant() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _isDarkModeON = _prefs.getBool('isDarkModeOn') ?? false;
    _accentColor = Color(_prefs.getInt('color') ?? lightAccent.value);
    _navbarAppvarColor =
        Color(_prefs.getInt('navbarappbar') ?? Colors.white.value);
    toggleTheme(_isDarkModeON);
  }

  toggleTheme(value) async {
    _isDarkModeON = value;
    _themeData = isDarkModeON ? darkTheme : lightTheme;
    await _prefs.setBool('isDarkModeOn', _isDarkModeON);
    notifyListeners();
  }

  setAccentColor(Color ac) async {
    _accentColor = ac;
    await _prefs.setInt('color', _accentColor.value);
    notifyListeners();
  }

  setNavIconAndAppbarTextColor(Color color) async {
    _navbarAppvarColor = color;
    await _prefs.setInt('navbarappbar', _navbarAppvarColor.value);
    notifyListeners();
  }

  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
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
    cardColor: Colors.grey.withOpacity(0.2),
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
