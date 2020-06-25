import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/create_playlist_dialog.dart';
import '../widgets/emptyscreen_widget.dart';
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
    final _query = Provider.of<AudioQuery>(context);
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
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.playlist_add,
                color: Theme.of(context).backgroundColor),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => CreatePlayListDialog(),
              );
            },
          ),
        ],
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
          screenContents: _query.playlist.length > 0
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.playlist_play,
                        color: Theme.of(context).accentColor),
                    title: Text(
                      _query.playlist[index].name ?? 'Playlist $index',
                      style: Constants.kListTileTitle,
                    ),
                    subtitle: Text(
                        'Song: ${_query.playlist[index].memberIds.length}'),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _query.removePlayList(_query.playlist[index]);
                          Fluttertoast.showToast(msg: 'removed playlist');
                        }),
                    onTap: () async {
                      _query.getSongsFromPlayList(_query.playlist[index]);
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
                )
              : EmptyScreenWidget(),
        ),
      ),
    );
  }
}
