import '../provider/audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _getMusicInfo();
    _navigateToHome();
    super.initState();
  }

  void _getMusicInfo() async {
    final _query = Provider.of<AudioQuery>(context, listen: false);
    await _query.getSongsInfo();
    await _query.getRandomSongsList();
    await _query.getAllAlbumInfo();
    await _query.getAllArtistInfo();
    await _query.getAllPlaylistInfo();
  }

  void _navigateToHome() {
    Future.delayed(
      Duration(milliseconds: 1500),
      () => Navigator.of(context).pushReplacementNamed('/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
