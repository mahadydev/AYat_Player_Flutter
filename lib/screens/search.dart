import 'dart:io';
import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import '../widgets/floatingbutton.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AudioQuery _query;
  AudioPlayer _audio;

  Future<List<SongInfo>> _getAllSongs(String text) async {
    final List<SongInfo> temp = _query.songs;
    List<SongInfo> suggestList = [];
    suggestList = temp
        .where((song) =>
            song.title.toLowerCase().contains(text.toLowerCase()) ||
            song.artist.toLowerCase().contains(text.toLowerCase()) ||
            song.album.toLowerCase().contains(text.toLowerCase()))
        .toList();
    return suggestList;
  }

  @override
  void initState() {
    _query = Provider.of<AudioQuery>(context, listen: false);
    _audio = Provider.of<AudioPlayer>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        title: Text(
          'SEARCH',
          style: Constants.kAppBarTitleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SearchBar<SongInfo>(
        minimumChars: 2,
        hintText: 'Search',
        hintStyle: Constants.kListTileSubTitle,
        textStyle: Constants.kListTileTitle,
        iconActiveColor: Theme.of(context).accentColor,
        searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
        listPadding: EdgeInsets.symmetric(horizontal: 10),
        searchBarStyle: SearchBarStyle(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        onSearch: _getAllSongs,
        placeHolder: Center(
          child: Text(
            "Search for music",
            style: Constants.kListTileTitle,
            textAlign: TextAlign.center,
          ),
        ),
        cancellationWidget: Text(
          "Cancel",
          style: Constants.kListTileTitle,
        ),
        emptyWidget: Center(
            child: Image.asset(
          'assets/empty.png',
          fit: BoxFit.contain,
        )),
        onCancelled: () {
          print("Cancelled triggered");
        },
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
        onItemFound: (SongInfo song, int index) {
          return GestureDetector(
            onTap: () {
              _audio.playSingleSong(song);
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.file(File(song.albumArtwork)),
                  Text(
                    'Title : ${song.title}',
                    style: Constants.kListTileTitle,
                  ),
                  Text(
                    'Artist : ${song.artist}',
                    style: Constants.kListTileTitle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
