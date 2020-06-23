import 'package:assets_audio_player/assets_audio_player.dart';
import '../data/sharedpref.dart';
import '../provider/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);
    final AudioPlayer _audio = Provider.of<AudioPlayer>(context);
    return _audio.playerState == PlayerState.stop
        ? SizedBox(
            height: 0,
            width: 0,
          )
        : FloatingActionButton.extended(
            heroTag: 'nowplaying',
            label: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: _audio.currentlyPlaying != null
                  ? Text(
                      _audio.currentlyPlaying.audio.metas.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontFamily: 'MetalMania'),
                    )
                  : Text('Now Playing'),
            ),
            isExtended: true,
            onPressed: () {
              _pref.nowPlayingScreen == 'C'
                  ? Navigator.of(context).pushNamed('/nowplaying')
                  : Navigator.of(context).pushNamed('/nowplaying2');
            },
            icon: CircleAvatar(
              child: _audio.isPlaying
                  ? Icon(
                      Icons.pause_circle_filled,
                      color: Theme.of(context).accentColor,
                    )
                  : Icon(
                      Icons.play_circle_filled,
                      color: Theme.of(context).accentColor,
                    ),
            ),
          );
  }
}
