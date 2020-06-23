import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../data/sharedpref.dart';
import '../provider/audio_player.dart';
import '../widgets/bottom_nowplaying_ayatbar.dart';
import '../widgets/nowplaying_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatelessWidget {
  //variables
  //get duration of the song
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
    Size _size = MediaQuery.of(context).size;
    final AudioPlayer _audio = Provider.of<AudioPlayer>(context);
    final SharedPersistantSettings _pref =
        Provider.of<SharedPersistantSettings>(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'nowplaying',
                      child: Container(
                        height: _size.height / 2.5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: _audio.currentlyPlaying != null &&
                                  _audio.currentlyPlaying.audio.metas.image
                                          .path !=
                                      null
                              ? Image.file(
                                  File(_audio
                                      .currentlyPlaying.audio.metas.image.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset('assets/empty.png',
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: _size.width,
                      child: Text(
                        _audio.currentlyPlaying != null &&
                                _audio.currentlyPlaying.audio.metas.title !=
                                    null
                            ? _audio.currentlyPlaying.audio.metas.title
                            : 'Play a Song',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MetalMania',
                          fontSize: 28,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: _size.width,
                      child: Text(
                        _audio.currentlyPlaying == null ||
                                _audio.currentlyPlaying.audio.metas.artist ==
                                    null
                            ? '-'
                            : _audio.currentlyPlaying.audio.metas.artist,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 16,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _printDuration(_audio.currentSongPosition),
                              ),
                              Text(
                                _printDuration(_audio.currentSongDuration),
                              ),
                            ],
                          ),
                          Container(
                            child: Slider(
                              value: _audio.currentSongPosition.inSeconds
                                  .roundToDouble(),
                              min: 0,
                              max: _audio.currentSongDuration.inSeconds
                                  .roundToDouble(),
                              onChanged: (value) {
                                _audio.seekAudio(value.round());
                              },
                              activeColor: Theme.of(context).accentColor,
                              inactiveColor: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            NowPlayingIcon(
                              height: 50,
                              icon: Icon(Icons.stop,
                                  size: 35,
                                  color: Theme.of(context).accentColor),
                              ontap: () {
                                _audio.stopSong();
                              },
                            ),
                            NowPlayingIcon(
                              height: 60,
                              icon: Icon(Icons.skip_previous,
                                  size: 40,
                                  color: Theme.of(context).accentColor),
                              ontap: () {
                                _audio.assetsAudioPlayer.previous();
                              },
                            ),
                            Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [
                                    Colors.deepPurple,
                                    Colors.greenAccent,
                                  ])),
                              child: GestureDetector(
                                onTap: () {
                                  _audio.playorPauseSong();
                                },
                                child: Center(
                                  child: Icon(
                                    _audio.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            NowPlayingIcon(
                              height: 60,
                              icon: Icon(Icons.skip_next,
                                  size: 40,
                                  color: Theme.of(context).accentColor),
                              ontap: () {
                                _audio.assetsAudioPlayer.next();
                              },
                            ),
                            NowPlayingIcon(
                              height: 50,
                              icon: Icon(
                                Icons.repeat_one,
                                size: 35,
                                color: _audio.loopMode == LoopMode.single
                                    ? Theme.of(context).accentColor
                                    : Colors.grey,
                              ),
                              ontap: () {
                                _audio.loopSong();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _pref.volumeControl
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.volume_down,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Icon(
                                      Icons.volume_up,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ],
                                ),
                                PlayerBuilder.volume(
                                  player: _audio.assetsAudioPlayer,
                                  builder: (context, volume) {
                                    return Slider(
                                      max: 1,
                                      min: 0.0,
                                      value: _audio.currentVolume,
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      inactiveColor:
                                          Theme.of(context).accentColor,
                                      onChanged: (value) {
                                        _audio.setVolume(value);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              BottomNowPlayingAyatBar(pref: _pref),
            ],
          ),
        ),
      ),
    );
  }
}
