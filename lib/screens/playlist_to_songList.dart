import 'dart:io';

import '../data/sharedpref.dart';
import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import '../widgets/floatingbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayListSongs extends StatelessWidget {
  final int playlistIndex;
  final String appBarTitle;
  PlayListSongs({this.playlistIndex, this.appBarTitle});
  @override
  Widget build(BuildContext context) {
    final _query = Provider.of<AudioQuery>(context);
    final _player = Provider.of<AudioPlayer>(context);
    final _pref = Provider.of<SharedPersistantSettings>(context);

    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        brightness: _pref.isDarkMode ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          appBarTitle,
          maxLines: 1,
          style: Constants.kAppBarTitleTextStyle
              .copyWith(color: Theme.of(context).backgroundColor),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).backgroundColor,
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
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _query.removeSongsListForPlayList(
                          _query.currentSongListforPlayList[index],
                          playlistIndex);
                    }),
              ),
            )
          : Center(
              child: Image.asset(
                'assets/empty.png',
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
