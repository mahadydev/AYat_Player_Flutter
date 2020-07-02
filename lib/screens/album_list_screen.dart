import '../util/theme_constants.dart';
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

class AlbumListScreen extends StatefulWidget {
  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  FSBStatus drawerStatus;
  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);
    final _prefTheme = Provider.of<ThemeConstants>(context);
    final _query = Provider.of<AudioQuery>(context);

    return Scaffold(
      appBar: AppBar(
        brightness:
            _prefTheme.isDarkModeON ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Album',
          style: Constants.kAppBarTitleTextStyle.copyWith(
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor),
        ),
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
              _pref.setAlbumListGridView(false);
            },
          ),
          IconButton(
            icon: Icon(
              MaterialIcons.grid_on,
              color: _prefTheme.navbarAppvarColor ??
                  Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              _pref.setAlbumListGridView(true);
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
                  list: 'album',
                  sortType: [
                    AlbumSortType.DEFAULT,
                    AlbumSortType.ALPHABETIC_ARTIST_NAME,
                    AlbumSortType.MOST_RECENT_YEAR,
                    AlbumSortType.OLDEST_YEAR,
                    AlbumSortType.LESS_SONGS_NUMBER_FIRST,
                    AlbumSortType.MORE_SONGS_NUMBER_FIRST,
                  ],
                  title: [
                    'default',
                    'alphabic artist name',
                    'most recent year',
                    'oldest year',
                    'less track in album',
                    'most track in album',
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
            screenContents:
                _query.albumList.length == 0 || _query.albumList.length == null
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
                          _pref.albumListGridView
                              ? SliverGridForAlbum(query: _query)
                              : SliverListForAlbum(query: _query)
                        ],
                      )),
      ),
    );
  }
}

class SliverListForAlbum extends StatelessWidget {
  const SliverListForAlbum({
    Key key,
    @required AudioQuery query,
  })  : _query = query,
        super(key: key);

  final AudioQuery _query;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GestureDetector(
          onTap: () {
            _query.setCurrentAlbumSelected(_query.albumList[index]);
            Navigator.of(context).pushNamed('/songfromalbum');
          },
          child: ListTileWidget(
            title: _query.albumList[index].title,
            imagePath: _query.albumList[index].albumArt,
            sub: _query.albumList[index].artist,
          ),
        ),
        childCount: _query.albumList.length,
      ),
    );
  }
}

class SliverGridForAlbum extends StatelessWidget {
  const SliverGridForAlbum({
    Key key,
    @required AudioQuery query,
  })  : _query = query,
        super(key: key);

  final AudioQuery _query;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GestureDetector(
          onTap: () {
            _query.setCurrentAlbumSelected(_query.albumList[index]);
            Navigator.of(context).pushNamed('/songfromalbum');
          },
          child: GridTileWidget(
            title: _query.albumList[index].title,
            imagePath: _query.albumList[index].albumArt,
            sub: _query.albumList[index].artist,
          ),
        ),
        childCount: _query.albumList.length,
      ),
    );
  }
}
