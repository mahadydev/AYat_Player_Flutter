import 'dart:io';

import '../widgets/custom_drawer.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import '../widgets/dashboard_artist_list.dart';
import '../provider/audio_query.dart';
import '../widgets/dashboard_albumlist.dart';
import '../widgets/dashboard_playlist.dart';
import '../widgets/dashboard_next_favorite.dart';
import '../widgets/ifnull_widget.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../util/constants.dart';
import '../widgets/dashboard_carousel.dart';
import '../data/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  FSBStatus drawerStatus;

  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);
    final _query = Provider.of<AudioQuery>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              MaterialCommunityIcons.menu,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              });
            }),
        automaticallyImplyLeading: false,
      ),
      body: SwipeDetector(
        onSwipeRight: () {
          setState(() {
            drawerStatus = FSBStatus.FSB_OPEN;
          });
        },
        onSwipeLeft: () {
          setState(() {
            drawerStatus = FSBStatus.FSB_CLOSE;
          });
        },
        swipeConfiguration: SwipeConfiguration(
            verticalSwipeMinVelocity: 75, horizontalSwipeMinVelocity: 75),
        child: FoldableSidebarBuilder(
          drawerBackgroundColor: Theme.of(context).backgroundColor,
          status: drawerStatus,
          drawer: CustomDrawer(
            closeDrawer: () {
              setState(() {
                drawerStatus = FSBStatus.FSB_CLOSE;
              });
            },
          ),
          screenContents: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              'HEY, ',
                              style: Constants.kListTileSubTitle,
                            ),
                            Text(
                              _pref.nickname.toUpperCase(),
                              style: Constants.kAppBarTitleTextStyle
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                        const Text(
                          'WELCOME',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                          ),
                        ),
                      ],
                    ),
                    _pref.photo.isEmpty || _pref.photo == null
                        ? CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/empty.png',
                            ),
                            radius: 30,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(File(_pref.photo)),
                            radius: 30,
                          ),
                  ],
                ),
                SizedBox(height: 20),
                if (_pref.isCarousel) DashBoardCarousel(),
                _query.songs.length > 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: YourNextFavoriteList(),
                      )
                    : IfNullWidget(
                        text: ' No Song Found',
                        icon: Icons.music_note,
                      ),
                _query.albumList.length > 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: DashBoardAlbumList(pref: _pref),
                      )
                    : IfNullWidget(
                        text: ' No Album Found',
                        icon: Icons.album,
                      ),
                _query.artistList.length > 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: DashboardArtistList(),
                      )
                    : IfNullWidget(
                        text: ' No Artist Found',
                        icon: MaterialCommunityIcons.artist,
                      ),
                _query.playlist.length > 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: DashBoardPlayList(),
                      )
                    : IfNullWidget(
                        text: ' No PlayList Created',
                        icon: Icons.playlist_play,
                      ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
