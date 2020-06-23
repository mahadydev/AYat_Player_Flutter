import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioQuery with ChangeNotifier {
  Random random = Random();

  /// create a FlutterAudioQuery instance.
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();

  List<SongInfo> _songs = [];
  List<AlbumInfo> _albumList = [];
  List<PlaylistInfo> _playlist = [];
  List<ArtistInfo> _artistList = [];
  AlbumInfo _currentAlbum;
  ArtistInfo _currentArtist;
  List<SongInfo> _currentSongListforAlbum = [];
  List<SongInfo> _randomSongList = [];
  List<SongInfo> _currentSongListforArtist = [];
  List<SongInfo> _currentSongListforPlayList = [];

  //getter
  List<SongInfo> get songs => [..._songs];
  List<PlaylistInfo> get playlist => [..._playlist];
  List<AlbumInfo> get albumList => _albumList;
  AlbumInfo get currentAlbum => _currentAlbum;
  ArtistInfo get currentArtist => _currentArtist;
  List<SongInfo> get currentSongListforAlbum => _currentSongListforAlbum;
  List<SongInfo> get randomSongList => _randomSongList;
  List<ArtistInfo> get artistList => [..._artistList];
  List<SongInfo> get currentSongListforArtist => _currentSongListforArtist;
  List<SongInfo> get currentSongListforPlayList => _currentSongListforPlayList;

  ///get all song info from device
  getSongsInfo({SongSortType sortType}) async {
    List<SongInfo> temp = [];
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int _filterSec = _prefs.getInt('filterSongSeconds') ?? 30;

    /// getting all songs available on device storage
    List<SongInfo> s =
        await _audioQuery.getSongs(sortType: sortType ?? SongSortType.DEFAULT);
    for (var song in s) {
      if (int.parse(song.duration) / 1000 > _filterSec) temp.add(song);
    }
    this._songs = temp;
    notifyListeners();
  }

  ///get random song list from device
  getRandomSongsList() {
    random = Random();
    List<SongInfo> tempList = this.songs;

    /// Go through all elements.
    for (var i = tempList.length - 1; i > 0; i--) {
      int n = random.nextInt(i + 1);
      SongInfo temp = tempList[i];
      tempList[i] = tempList[n];
      tempList[n] = temp;
    }
    this._randomSongList = tempList;
    notifyListeners();
  }

  ///get all artist information from device
  getAllArtistInfo({ArtistSortType artistSortType}) async {
    this._artistList = await _audioQuery.getArtists(
        sortType: artistSortType ?? ArtistSortType.DEFAULT);
    notifyListeners();
  }

  ///get all Album info from device
  getAllAlbumInfo({AlbumSortType albumSortType}) async {
    /// getting all albums available on device storage
    this._albumList = await _audioQuery.getAlbums(
        sortType: albumSortType ?? AlbumSortType.DEFAULT);
    notifyListeners();
  }

  ///get all Playlist info from device
  getAllPlaylistInfo() async {
    /// getting all Playlist available on device storage
    this._playlist = await _audioQuery.getPlaylists();
    notifyListeners();
  }

  ///set album for global access
  setCurrentAlbumSelected(AlbumInfo album) async {
    this._currentAlbum = album;
    await getSongsFromAlbum(album.id);
    notifyListeners();
  }

  ///set artist for global access
  setCurrentArtistSelected(ArtistInfo artist) async {
    this._currentArtist = artist;
    await getSongsFromArtist(artist.name);
    notifyListeners();
  }

  ///get song list from album id
  getSongsFromAlbum(String id) async {
    this._currentSongListforAlbum =
        await _audioQuery.getSongsFromAlbum(albumId: id);
  }

  ///get song list from artist name
  getSongsFromArtist(String artist) async {
    this._currentSongListforArtist =
        await _audioQuery.getSongsFromArtist(artist: artist);
  }

  ///get PlayList songs for specific playlist
  getSongsFromPlayList(PlaylistInfo playlist) async {
    _currentSongListforPlayList =
        await _audioQuery.getSongsFromPlaylist(playlist: playlist);
    notifyListeners();
  }

  ///Add  songs from PlayList
  addSongsListToPlayList(SongInfo song, playlistIndex) async {
    List<PlaylistInfo> _temp = _playlist;
    await _temp[playlistIndex].addSong(song: song);
    this._playlist = _temp;
    getSongsFromPlayList(this._playlist[playlistIndex]);
  }

  ///remove  songs from PlayList
  removeSongsListForPlayList(SongInfo song, playlistIndex) async {
    List<PlaylistInfo> _temp = _playlist;
    await _temp[playlistIndex].removeSong(song: song);
    this._playlist = _temp;
    getSongsFromPlayList(this._playlist[playlistIndex]);
  }
}
