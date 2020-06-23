import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class AudioPlayer with ChangeNotifier {
  AssetsAudioPlayer assetsAudioPlayer =
      AssetsAudioPlayer.withId('MY_UNIQUE_ID');
  List<StreamSubscription> _subscriptions = [];

  ///Getter variables for AudioPlayer
  bool isPlaying = false;
  Duration currentSongDuration = Duration(seconds: 0);
  Duration currentSongPosition = Duration(seconds: 0);
  double currentVolume = 1.0;
  LoopMode loopMode = LoopMode.none;
  PlayerState playerState = PlayerState.stop;
  PlayingAudio currentlyPlaying;

  AudioPlayer() {
    initPlayer();
  }

  initPlayer() {
    // _subscriptions.add(assetsAudioPlayer.playlistFinished.listen((finished) {
    //   print("finished : $finished");
    // }));
    // _subscriptions
    //     .add(assetsAudioPlayer.playlistAudioFinished.listen((finished) {
    // }));
    _subscriptions.add(assetsAudioPlayer.current.listen((playing) {
      currentSongDuration = playing.audio.duration;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.currentPosition.listen((position) {
      currentSongPosition = position;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.volume.listen((volume) {
      currentVolume = volume;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.loopMode.listen((loopmode) {
      loopMode = loopmode;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.onReadyToPlay.listen((audio) {
      currentlyPlaying = audio;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.playerState.listen((playerstate) {
      playerState = playerstate;
      notifyListeners();
    }));
    _subscriptions.add(assetsAudioPlayer.isPlaying.listen((isplaying) {
      isPlaying = isplaying;
      notifyListeners();
    }));
    // _subscriptions
    //     .add(AssetsAudioPlayer.addNotificationOpenAction((notification) {
    //   print(notification);
    //   return false;
    // }));
  }

  //Play a song
  playSingleSong(SongInfo songInfo) {
    assetsAudioPlayer.open(
      Audio.file(
        songInfo.filePath,
        metas: Metas(
          title: songInfo.title,
          artist: songInfo.artist,
          album: songInfo.album,
          image: MetasImage.file(songInfo.albumArtwork),
        ),
      ),
      playInBackground: PlayInBackground.enabled,
      showNotification: true,
      notificationSettings: NotificationSettings(),
    );

    notifyListeners();
  }

  initPlaylistSounds(List<SongInfo> songsList, int index) {
    assetsAudioPlayer.open(
      Playlist(
        audios: convertsongListToPlayList(
          songsList,
        ),
        startIndex: index,
      ),
      showNotification: true,
      playInBackground: PlayInBackground.enabled,
      notificationSettings: NotificationSettings(),
    );
  }

  //Play song from playlist
  List<Audio> convertsongListToPlayList(List<SongInfo> songsList) {
    List<Audio> playlist = List();

    for (var song in songsList) {
      playlist.add(
        Audio.file(
          song.filePath,
          metas: Metas(
            title: song.title,
            artist: song.artist,
            album: song.album,
            image: song.albumArtwork == null
                ? MetasImage.asset("assets/empty.png")
                : MetasImage.file(song.albumArtwork),
          ),
        ),
      );
    }
    return playlist;
  }

  //Play or Pause a song
  playorPauseSong() => assetsAudioPlayer.playOrPause();

  //toogle loop on or off
  loopSong() => assetsAudioPlayer.toggleLoop();

  //seek audio song
  seekAudio(int duration) =>
      assetsAudioPlayer.seek(Duration(seconds: duration));

  //Stop a song
  stopSong() {
    assetsAudioPlayer.stop();
  }

  //volume control
  setVolume(double vol) => assetsAudioPlayer.setVolume(vol);
}
