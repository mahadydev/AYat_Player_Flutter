import '../screens/album_to_songList.dart';
import '../screens/edit_profile.dart';
import '../screens/now_playing__screen_2.dart';
import '../screens/settings.dart';
import '../screens/now_playing_screen.dart';
import '../screens/home.dart';
import '../screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../screens/artist_to_songList.dart';
import '../screens/search.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/home': (BuildContext context) => Home(),
  '/nowplaying': (BuildContext context) => NowPlaying(),
  '/nowplaying2': (BuildContext context) => NowPlayingNew(),
  '/settings': (BuildContext context) => Settings(),
  '/songfromalbum': (BuildContext context) => SongListFromAlbum(),
  '/profile': (BuildContext context) => EditProfile(),
  '/songfromartist': (BuildContext context) => SongListFromArtist(),
  '/search': (BuildContext context) => SearchScreen(),
};
