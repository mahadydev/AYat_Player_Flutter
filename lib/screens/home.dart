import 'package:flutter_icons/flutter_icons.dart';

import '../provider/audio_player.dart';
import '../screens/artist_list_screen.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import '../screens/album_list_screen.dart';
import '../screens/playlistscreen.dart';
import '../screens/dashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../widgets/floatingbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Music_list.dart';
import '../util/theme_constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<AudioPlayer>(context, listen: false)
        .assetsAudioPlayer
        .dispose();
    _pageController.dispose();
    print('disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<ThemeConstants>(context);
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          key: _bottomNavigationKey,
          height: _size.height > 650 ? 55.0 : 45.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          color: Theme.of(context).accentColor,
          buttonBackgroundColor: Theme.of(context).accentColor,
          animationCurve: Curves.linearToEaseOut,
          animationDuration: Duration(milliseconds: 500),
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          items: <Widget>[
            Icon(Icons.dashboard,
                size: _size.height > 650 ? 30 : 25,
                color:
                    _pref.navbarAppvarColor ?? Theme.of(context).primaryColor),
            Icon(Icons.music_note,
                size: _size.height > 650 ? 30 : 25,
                color:
                    _pref.navbarAppvarColor ?? Theme.of(context).primaryColor),
            Icon(Icons.album,
                size: _size.height > 650 ? 30 : 25,
                color:
                    _pref.navbarAppvarColor ?? Theme.of(context).primaryColor),
            Icon(MaterialCommunityIcons.artist,
                size: _size.height > 650 ? 30 : 25,
                color:
                    _pref.navbarAppvarColor ?? Theme.of(context).primaryColor),
            Icon(Icons.playlist_play,
                size: _size.height > 650 ? 30 : 25,
                color:
                    _pref.navbarAppvarColor ?? Theme.of(context).primaryColor),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            final CurvedNavigationBarState navBarState =
                _bottomNavigationKey.currentState;
            navBarState.setPage(index);
          },
          children: <Widget>[
            DashBoard(),
            MusicList(),
            AlbumListScreen(),
            ArtistListScreen(),
            PlayListScreen(),
            //GenreListScreen(),
          ],
        ),
      ),
    );
  }
}
