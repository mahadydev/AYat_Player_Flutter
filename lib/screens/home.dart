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
import '../widgets/bottom_navigationbar.dart' as bnb;
import 'Music_list.dart';

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
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: bnb.BottomNavigationBar(
          bottomNavigationKey: _bottomNavigationKey,
          pageController: _pageController,
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
