import '../data/sharedpref.dart';
import '../screens/playlist_to_songList.dart';
import '../util/constants.dart';
import '../widgets/custom_drawer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import '../provider/audio_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatefulWidget {
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  FSBStatus drawerStatus;
  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: _pref.isDarkMode ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Playlist',
          style: Constants.kAppBarTitleTextStyle
              .copyWith(color: Theme.of(context).backgroundColor),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              MaterialCommunityIcons.menu,
              color: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              });
            }),
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
          screenContents: Column(
            children: <Widget>[
              Flexible(
                child: Consumer<AudioQuery>(
                  builder: (context, AudioQuery _query, _) => _query
                                  .playlist.length ==
                              0 ||
                          _query.playlist.length == null
                      ? Center(
                          child: Container(
                            height: MediaQuery.of(context).size.width / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Image.asset(
                              'assets/empty.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.playlist_play,
                                  color: Theme.of(context).accentColor),
                            ),
                            title: Text(
                              _query.playlist[index].name ?? '-',
                              style: Constants.kListTileTitle,
                            ),
                            onTap: () async {
                              _query
                                  .getSongsFromPlayList(_query.playlist[index]);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlayListSongs(
                                    playlistIndex: index,
                                    appBarTitle: _query.playlist[index].name,
                                  ),
                                ),
                              );
                            },
                          ),
                          itemCount: _query.playlist.length ?? 0,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
