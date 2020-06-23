import '../provider/audio_player.dart';
import '../provider/audio_query.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';

import 'float_modal.dart';

class ModalFit extends StatelessWidget {
  final ScrollController scrollController;
  final List<SongInfo> songs;
  final int index;
  final AudioPlayer audio;

  const ModalFit({
    Key key,
    this.scrollController,
    this.index,
    this.audio,
    this.songs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _query = Provider.of<AudioQuery>(context);
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Play Song'),
            leading:
                Icon(Icons.play_arrow, color: Theme.of(context).accentColor),
            onTap: () {
              audio.initPlaylistSounds(songs, index);
              Navigator.of(context).pop();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Add to Playlist'),
            leading:
                Icon(Icons.playlist_add, color: Theme.of(context).accentColor),
            onTap: () {
              Navigator.of(context).pop();
              showFloatingModalBottomSheet(
                backgroundColor: Theme.of(context).backgroundColor,
                context: context,
                builder: (context, scrollController) => Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: _query.playlist.length < 1
                      ? Center(
                          child: Text('No Playlist Found'),
                        )
                      : ListView.builder(
                          itemBuilder: (context, playListIndex) => ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.playlist_add,
                                  color: Theme.of(context).accentColor),
                            ),
                            title: Text(
                                _query.playlist[playListIndex].name ?? '-'),
                            onTap: () async {
                              _query.addSongsListToPlayList(
                                  songs[index], playListIndex);
                              Navigator.of(context).pop();
                            },
                          ),
                          itemCount: _query.playlist.length ?? 0,
                        ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Info'),
            leading:
                Icon(Icons.info_outline, color: Theme.of(context).accentColor),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) => FancyDialog(
                  theme: FancyTheme.FANCY,
                  animationType: FancyAnimation.BOTTOM_TOP,
                  gifPath: FancyGif.PLAY_MEDIA,
                  title: songs[index].title ?? '',
                  descreption:
                      'FilePath: ${songs[index].filePath}\nSize: ${double.parse((double.parse(songs[index].fileSize) / 1000000).toStringAsFixed(2))}MB',
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
