import 'package:ayat_player_flutter_player/util/theme_constants.dart';

import '../data/sharedpref.dart';
import '../util/constants.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/float_modal.dart';
import '../widgets/sorting_bottomsheet.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:swipedetector/swipedetector.dart';
import '../widgets/gridview_widget.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../provider/audio_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import '../widgets/emptyscreen_widget.dart';
import '../widgets/listview_widget.dart';

class ArtistListScreen extends StatefulWidget {
  @override
  _ArtistListScreenState createState() => _ArtistListScreenState();
}

class _ArtistListScreenState extends State<ArtistListScreen> {
  FSBStatus drawerStatus;
  @override
  Widget build(BuildContext context) {
    final _prefTheme = Provider.of<ThemeConstants>(context);
    final _pref = Provider.of<SharedPersistantSettings>(context);
    final _query = Provider.of<AudioQuery>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artist',
          style: Constants.kAppBarTitleTextStyle.copyWith(
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor),
        ),
        brightness:
            _prefTheme.isDarkModeON ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              MaterialCommunityIcons.menu,
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              setState(() {
                drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                    ? FSBStatus.FSB_CLOSE
                    : FSBStatus.FSB_OPEN;
              });
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MaterialCommunityIcons.view_list,
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              _pref.setArtistListGridView(false);
            },
          ),
          IconButton(
            icon: Icon(
              MaterialIcons.grid_on,
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              _pref.setArtistListGridView(true);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.sort,
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              showFloatingModalBottomSheet(
                backgroundColor: Theme.of(context).backgroundColor,
                context: context,
                builder: (context, scrollController) => SortingBottomSheet(
                  list: 'artist',
                  sortType: [
                    ArtistSortType.DEFAULT,
                    ArtistSortType.LESS_ALBUMS_NUMBER_FIRST,
                    ArtistSortType.MORE_ALBUMS_NUMBER_FIRST,
                    ArtistSortType.LESS_TRACKS_NUMBER_FIRST,
                    ArtistSortType.MORE_TRACKS_NUMBER_FIRST,
                  ],
                  title: [
                    'default',
                    'less album',
                    'more album',
                    'less track',
                    'most track',
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
            screenContents: _query.artistList.length == 0 ||
                    _query.artistList.length == null
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
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: ListTile(
                            title: Text(
                              'Search',
                              style: Constants.kListTileSubTitle.copyWith(
                                color: _prefTheme.navbarAppvarColor ??
                                    Theme.of(context).backgroundColor,
                              ),
                            ),
                            leading: Icon(
                              Icons.search,
                              color: _prefTheme.navbarAppvarColor ??
                                  Theme.of(context).backgroundColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed('/search');
                            },
                          ),
                        ),
                      ),
                      _pref.artistListGridView
                          ? SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 4 / 5,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    GestureDetector(
                                  onTap: () {
                                    _query.setCurrentArtistSelected(
                                        _query.artistList[index]);
                                    Navigator.of(context)
                                        .pushNamed('/songfromartist');
                                  },
                                  child: GridTileWidget(
                                    title: _query.artistList[index].name,
                                    imagePath:
                                        _query.artistList[index].artistArtPath,
                                    sub:
                                        'Song :${_query.artistList[index].numberOfTracks}\nAlbum :${_query.artistList[index].numberOfAlbums}',
                                  ),
                                ),
                                childCount: _query.albumList.length,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => GestureDetector(
                                  onTap: () {
                                    _query.setCurrentArtistSelected(
                                        _query.artistList[index]);
                                    Navigator.of(context)
                                        .pushNamed('/songfromartist');
                                  },
                                  child: ListTileWidget(
                                    title: _query.artistList[index].name,
                                    imagePath:
                                        _query.artistList[index].artistArtPath,
                                    sub:
                                        'Song :${_query.artistList[index].numberOfTracks}\nAlbum :${_query.artistList[index].numberOfAlbums}',
                                  ),
                                ),
                                childCount: _query.artistList.length,
                              ),
                            )
                    ],
                  )),
      ),
    );
  }
}
