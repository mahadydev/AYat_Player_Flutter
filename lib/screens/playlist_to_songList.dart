import 'dart:io';

import '../util/theme_constants.dart';
import '../widgets/emptyscreen_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import '../widgets/floatingbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayListSongs extends StatefulWidget {
  final int playlistIndex;
  final String appBarTitle;
  PlayListSongs({this.playlistIndex, this.appBarTitle});

  @override
  _PlayListSongsState createState() => _PlayListSongsState();
}

class _PlayListSongsState extends State<PlayListSongs> {
  @override
  Widget build(BuildContext context) {
    final _query = Provider.of<AudioQuery>(context);
    final _player = Provider.of<AudioPlayer>(context);
    final _pref = Provider.of<ThemeConstants>(context);

    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        brightness: _pref.isDarkModeON ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          widget.appBarTitle,
          maxLines: 1,
          style: Constants.kAppBarTitleTextStyle.copyWith(
              color:
                  _pref.navbarAppvarColor ?? Theme.of(context).backgroundColor),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  _pref.navbarAppvarColor ?? Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
      ),
      body: _query.currentSongListforPlayList.length > 0
          ? ListView.builder(
              itemCount: _query.currentSongListforPlayList.length ?? 0,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      _query.currentSongListforPlayList[index].albumArtwork !=
                              null
                          ? FileImage(
                              File(_query.currentSongListforPlayList[index]
                                  .albumArtwork),
                            )
                          : AssetImage('assets/empty.png'),
                ),
                title: Text(
                  _query.currentSongListforPlayList[index].title,
                  style: Constants.kListTileTitle,
                ),
                subtitle: Text(
                  _query.currentSongListforPlayList[index].artist,
                  style: Constants.kListTileTitle,
                ),
                onTap: () {
                  _player.initPlaylistSounds(
                      _query.currentSongListforPlayList, index);
                },
                trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(msg: 'removed song from playlist');
                      _query.removeSongsListForPlayList(
                          _query.currentSongListforPlayList[index],
                          widget.playlistIndex);
                    }),
              ),
            )
          : EmptyScreenWidget(),
    );
  }
}
