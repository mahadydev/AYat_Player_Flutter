import 'dart:io';
import '../data/sharedpref.dart';
import '../widgets/float_modal.dart';
import '../widgets/sorting_bottomsheet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import '../widgets/custom_drawer.dart';
import '../provider/audio_player.dart';
import '../util/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/emptyscreen_widget.dart';
import 'package:swipedetector/swipedetector.dart';
import '../provider/audio_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/modalfit.dart';

class MusicList extends StatefulWidget {
  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  FSBStatus drawerStatus;

  @override
  Widget build(BuildContext context) {
    final _query = Provider.of<AudioQuery>(context);
    final _player = Provider.of<AudioPlayer>(context);
    final _pref = Provider.of<SharedPersistantSettings>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: _pref.isDarkMode ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Music',
          style: Constants.kAppBarTitleTextStyle.copyWith(
            color: Theme.of(context).backgroundColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            MaterialCommunityIcons.menu,
            color: Theme.of(context).backgroundColor,
          ),
          onPressed: () {
            setState(
              () {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).backgroundColor,
            ),
            onPressed: () => Navigator.of(context).pushNamed('/search'),
          ),
          IconButton(
            icon: Icon(
              Icons.sort,
              color: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              showFloatingModalBottomSheet(
                backgroundColor: Theme.of(context).backgroundColor,
                context: context,
                builder: (context, scrollController) => SortingBottomSheet(
                  list: 'song',
                  sortType: [
                    SongSortType.DEFAULT,
                    SongSortType.ALPHABETIC_ARTIST,
                    SongSortType.ALPHABETIC_COMPOSER,
                    SongSortType.RECENT_YEAR,
                    SongSortType.OLDEST_YEAR,
                    SongSortType.GREATER_DURATION,
                    SongSortType.SMALLER_DURATION,
                  ],
                  title: [
                    'default',
                    'artist',
                    'composer',
                    'recent year',
                    'oldest year',
                    'greater duration',
                    'smaller duration'
                  ],
                ),
              );
            },
          )
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
          screenContents: _query.songs.length == 0 ||
                  _query.songs.length == null
              ? EmptyScreenWidget()
              : CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).accentColor,
                      automaticallyImplyLeading: false,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                      flexibleSpace: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: RaisedButton.icon(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          onPressed: () {
                                            _player.initPlaylistSounds(
                                                _query.songs, 0);
                                          },
                                          icon: Icon(
                                            Icons.play_arrow,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          label: Text(
                                            'Play All',
                                            style: Constants.kListTileSubTitle,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: RaisedButton.icon(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          onPressed: () {
                                            _player.initPlaylistSounds(
                                                _query.randomSongList, 0);
                                          },
                                          icon: Icon(
                                            Icons.shuffle,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          label: Text(
                                            'Suffle',
                                            style: Constants.kListTileSubTitle,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                          leading: _query.songs[index].albumArtwork != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(
                                      File(_query.songs[index].albumArtwork)),
                                )
                              : CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                          title: Text(_query.songs[index].title),
                          subtitle: Text(_query.songs[index].artist),
                          onTap: () {
                            _player.initPlaylistSounds(_query.songs, index);
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              showFloatingModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                context: context,
                                builder: (context, scrollController) =>
                                    ModalFit(
                                  scrollController: scrollController,
                                  songs: _query.songs,
                                  index: index,
                                  audio: _player,
                                ),
                              );
                            },
                          ),
                          onLongPress: () {
                            showFloatingModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              context: context,
                              builder: (context, scrollController) => ModalFit(
                                scrollController: scrollController,
                                songs: _query.songs,
                                index: index,
                                audio: _player,
                              ),
                            );
                          },
                        ),
                        childCount: _query.songs.length ?? 0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
