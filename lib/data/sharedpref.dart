import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPersistantSettings with ChangeNotifier {
  SharedPreferences _prefs;

  ///initial values
  bool _isDarkMode = false;
  bool _isFilter30Sec = false;
  bool _isCarousel = true;
  bool _homeAlbumGrid = false;
  bool _volumeControl = true;
  int _filterSongSeconds = 30;
  String _nowPlayingScreen = 'C';
  bool _albumListGridView = true;
  bool _artistListGridView = false;
  String _nickname = 'User';
  String _email = '';
  String _photo = '';

  ///getter
  bool get isDarkMode => _isDarkMode;
  bool get isFilter30Sec => _isFilter30Sec;
  bool get isCarousel => _isCarousel;
  bool get homeAlbumGrid => _homeAlbumGrid;
  bool get volumeControl => _volumeControl;
  bool get albumListGridView => _albumListGridView;
  bool get artistListGridView => _artistListGridView;
  int get filterSongSeconds => _filterSongSeconds;
  String get nowPlayingScreen => _nowPlayingScreen;
  String get nickname => _nickname;
  String get email => _email;
  String get photo => _photo;

  SharedPersistantSettings() {
    _loadSettings();
  }

  _initPref() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  ///initial value will be set on start of the app
  _loadSettings() async {
    await _initPref();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _isCarousel = _prefs.getBool('isCarousel') ?? true;
    _homeAlbumGrid = _prefs.getBool('homeAlbumGrid') ?? false;
    _volumeControl = _prefs.getBool('volumeControl') ?? true;
    _albumListGridView = _prefs.getBool('albumListGridView') ?? true;
    _artistListGridView = _prefs.getBool('artistListGridView') ?? false;
    _filterSongSeconds = _prefs.getInt('filterSongSeconds') ?? 30;
    _nowPlayingScreen = _prefs.getString('nowPlayingScreen') ?? 'C';
    _nickname = _prefs.getString('nickname') ?? 'User';
    _email = _prefs.getString('email') ?? '';
    _photo = _prefs.getString('photo') ?? '';

    notifyListeners();
  }

  ///set image path to device
  setImage(String path) async {
    _photo = path;
    await _initPref();
    _prefs.setString('photo', _photo);
    notifyListeners();
  }

  ///set and save profile name email
  setNickEmail(String email, String nick) async {
    _nickname = nick;
    _email = email;
    await _initPref();
    _prefs.setString('nickname', _nickname);
    _prefs.setString('email', _email);
    notifyListeners();
  }

  ///set and save darkmode Settings
  setDarkMode(bool d) async {
    _isDarkMode = d;
    await _initPref();
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ///set Grid/List View on Album Screen
  setAlbumListGridView(bool v) async {
    _albumListGridView = v;
    await _initPref();
    _prefs.setBool('albumListGridView', _albumListGridView);
    notifyListeners();
  }

  ///set Grid/List View on Artist Screen
  setArtistListGridView(bool v) async {
    _artistListGridView = v;
    await _initPref();
    _prefs.setBool('artistListGridView', _artistListGridView);
    notifyListeners();
  }

  ///set and save Carousel Settings
  setCarousel(bool c) async {
    _isCarousel = c;
    await _initPref();
    _prefs.setBool('isCarousel', _isCarousel);
    notifyListeners();
  }

  ///set and save Home Album Grid Settings
  setHomeAlbumGrid(bool a) async {
    _homeAlbumGrid = a;
    await _initPref();
    _prefs.setBool('homeAlbumGrid', _homeAlbumGrid);
    notifyListeners();
  }

  ///set and save VolumeControl Settings for now playing screen
  setVolumeControl(bool v) async {
    _volumeControl = v;
    await _initPref();
    _prefs.setBool('volumeControl', _volumeControl);
    notifyListeners();
  }

  //Set Filter for Songs
  setFilterSec(int f) async {
    _filterSongSeconds = f;
    await _initPref();
    _prefs.setInt('filterSongSeconds', _filterSongSeconds);
    notifyListeners();
  }

  //Set NowPlaying Screen for Songs
  setNowPlayingScreen(String n) async {
    _nowPlayingScreen = n;
    await _initPref();
    _prefs.setString('nowPlayingScreen', _nowPlayingScreen);
    notifyListeners();
  }
}
