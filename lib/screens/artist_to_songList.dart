import 'dart:io';
import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import '../widgets/floatingbutton.dart';
import 'package:flutter/material.dart';
import '../widgets/float_modal.dart';
import '../widgets/modalfit.dart';
import 'package:provider/provider.dart';

class SongListFromArtist extends StatelessWidget {
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
    ///variables
    final _size = MediaQuery.of(context).size;
    final _query = Provider.of<AudioQuery>(context);
    final _audio = Provider.of<AudioPlayer>(context);
    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        title: Text(
          'Music',
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
                  _query.currentArtist.artistArtPath != null
                      ? Expanded(
                          child: Image.file(
                            File(_query.currentArtist.artistArtPath),
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
                            _query.currentArtist.name,
                            style: Constants.kAppBarTitleTextStyle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Album :${_query.currentArtist.numberOfAlbums}' ??
                                '-',
                            style: Constants.kListTileSubTitle,
                          ),
                          Text(
                            'Track :${_query.currentArtist.numberOfTracks}' ??
                                '-',
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
                                  _query.currentSongListforArtist, index);
                            },
                            leading: CircleAvatar(
                              backgroundImage: _query
                                          .currentSongListforArtist[index]
                                          .albumArtwork !=
                                      null
                                  ? FileImage(File(_query
                                      .currentSongListforArtist[index]
                                      .albumArtwork))
                                  : AssetImage('assets/empty.png'),
                            ),
                            title: Text(
                              _query.currentSongListforArtist[index].title !=
                                      null
                                  ? _query.currentSongListforArtist[index].title
                                  : '-',
                              style: Constants.kListTileTitle.copyWith(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            trailing: Text(
                              _printDuration(
                                Duration(
                                  milliseconds: (int.parse(_query
                                      .currentSongListforArtist[index]
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
                                  songs: _query.currentSongListforArtist,
                                  index: index,
                                  audio: _audio,
                                ),
                              );
                            },
                          ),
                          itemCount:
                              _query.currentSongListforArtist.length ?? 0,
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
