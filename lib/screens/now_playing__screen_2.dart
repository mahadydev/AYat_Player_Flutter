import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import '../util/theme_constants.dart';
import '../data/sharedpref.dart';
import '../provider/audio_player.dart';
import '../widgets/nowplaying_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingNew extends StatefulWidget {
  @override
  _NowPlayingNewState createState() => _NowPlayingNewState();
}

class _NowPlayingNewState extends State<NowPlayingNew>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
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
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 15000));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    print('dispose ');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //variables
    Size _size = MediaQuery.of(context).size;
    final AudioPlayer _audio = Provider.of<AudioPlayer>(context);
    final ThemeConstants _prefTheme = Provider.of<ThemeConstants>(context);
    final SharedPersistantSettings _pref =
        Provider.of<SharedPersistantSettings>(context);

    //animation control if audio play / pause / stop
    if (_audio.playerState == PlayerState.play)
      _animationController.repeat();
    else if (_audio.playerState == PlayerState.pause)
      _animationController.stop();
    else
      _animationController.reset();

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
                      child: RotationTransition(
                        turns: _animation,
                        child: Container(
                          height: _size.height * 0.4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ClipOval(
                            child: _audio.currentlyPlaying != null &&
                                    _audio.currentlyPlaying.audio.metas.image
                                            .path !=
                                        null &&
                                    _audio.currentlyPlaying.audio.metas.image
                                            .path !=
                                        'assets/empty.png'
                                ? Image.file(File(_audio
                                    .currentlyPlaying.audio.metas.image.path))
                                : Image.asset('assets/empty.png',
                                    fit: BoxFit.cover),
                          ),
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
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 28,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: _size.width,
                      child: Text(
                        _audio.currentlyPlaying == null ||
                                _audio.currentlyPlaying.audio.metas.artist ==
                                    null
                            ? '-'
                            : _audio.currentlyPlaying.audio.metas.artist,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 16,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
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
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.250,
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: OvalTopBorderClipper(),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: _prefTheme.isDarkModeON
                                      ? LinearGradient(colors: [
                                          Color(0xffec008c),
                                          Color(0xfffc6767),
                                        ])
                                      : LinearGradient(colors: [
                                          Color(0xffb92b27),
                                          Color(0xff8E2DE2),
                                        ])),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    NowPlayingIcon(
                                      height: 50,
                                      icon: Icon(Icons.skip_previous,
                                          size: 35, color: Colors.white),
                                      ontap: () {
                                        _audio.assetsAudioPlayer.previous();
                                      },
                                    ),
                                    Container(
                                      height: 80,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [
                                            Colors.red,
                                            Colors.redAccent,
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
                                      height: 50,
                                      icon: Icon(Icons.skip_next,
                                          size: 35, color: Colors.white),
                                      ontap: () {
                                        _audio.assetsAudioPlayer.next();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              _pref.volumeControl
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _audio.stopSong();
                                            },
                                            child: Icon(
                                              Icons.stop,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.volume_down,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: _size.width * 0.550,
                                            child: PlayerBuilder.volume(
                                              player: _audio.assetsAudioPlayer,
                                              builder: (context, volume) {
                                                return Slider(
                                                  max: 1,
                                                  min: 0.0,
                                                  value: _audio.currentVolume,
                                                  activeColor: Theme.of(context)
                                                      .accentColor,
                                                  inactiveColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  onChanged: (value) {
                                                    _audio.setVolume(value);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Icon(
                                            Icons.volume_up,
                                            color: Colors.white,
                                          ),
                                          if (_audio.loopMode ==
                                              LoopMode.single)
                                            GestureDetector(
                                              onTap: () {
                                                _audio.loopSong();
                                              },
                                              child: Icon(Icons.repeat_one,
                                                  color: Colors.white),
                                            ),
                                          if (_audio.loopMode == LoopMode.none)
                                            GestureDetector(
                                              onTap: () {
                                                _audio.loopSong();
                                              },
                                              child: Icon(Icons.repeat,
                                                  color: Colors.grey),
                                            ),
                                          if (_audio.loopMode ==
                                              LoopMode.playlist)
                                            GestureDetector(
                                              onTap: () {
                                                _audio.loopSong();
                                              },
                                              child: Icon(Icons.repeat,
                                                  color: Colors.white),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OvalTopBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.40);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(
        size.width - size.width / 4, 0, size.width, size.height * 0.40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
