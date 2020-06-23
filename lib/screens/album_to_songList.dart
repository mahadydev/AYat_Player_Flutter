import 'dart:io';
import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import '../widgets/float_modal.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/modalfit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongListFromAlbum extends StatelessWidget {
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _query = Provider.of<AudioQuery>(context);
    final _audio = Provider.of<AudioPlayer>(context);
    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        title: Text(
          'Album',
          style: Constants.kAppBarTitleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Container(
              height: _size.height * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _query.currentAlbum.albumArt != null
                      ? Expanded(
                          child: Image.file(
                            File(_query.currentAlbum.albumArt),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Expanded(
                          child: Image.asset(
                            'assets/empty.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _query.currentAlbum.title ?? '-',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Constants.kAppBarTitleTextStyle,
                          ),
                          Text(
                            _query.currentAlbum.artist ?? '-',
                            style: Constants.kListTileSubTitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_query.currentAlbum.numberOfSongs != null)
                            Text(
                              'track :${_query.currentAlbum.numberOfSongs}',
                              style: Constants.kListTileSubTitle,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Song List',
                    style: Constants.kAppBarTitleTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                        ),
                        child: ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            onTap: () {
                              _audio.initPlaylistSounds(
                                  _query.currentSongListforAlbum, index);
                            },
                            leading: CircleAvatar(
                              backgroundImage: _query
                                          .currentSongListforAlbum[index]
                                          .albumArtwork !=
                                      null
                                  ? FileImage(
                                      File(
                                        _query.currentSongListforAlbum[index]
                                            .albumArtwork,
                                      ),
                                    )
                                  : AssetImage('assets/empty.png'),
                            ),
                            title: Text(
                              _query.currentSongListforAlbum[index].title,
                              style: Constants.kListTileTitle.copyWith(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            trailing: Text(
                              _printDuration(
                                Duration(
                                  milliseconds: (int.parse(_query
                                      .currentSongListforAlbum[index]
                                      .duration)),
                                ),
                              ),
                              style: Constants.kListTileSubTitle.copyWith(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            onLongPress: () {
                              showFloatingModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                context: context,
                                builder: (context, scrollController) =>
                                    ModalFit(
                                  scrollController: scrollController,
                                  songs: _query.currentSongListforAlbum,
                                  index: index,
                                  audio: _audio,
                                ),
                              );
                            },
                          ),
                          itemCount: _query.currentSongListforAlbum.length ?? 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
