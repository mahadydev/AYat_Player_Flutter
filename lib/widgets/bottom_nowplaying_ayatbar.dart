import '../data/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNowPlayingAyatBar extends StatelessWidget {
  const BottomNowPlayingAyatBar({
    Key key,
    @required SharedPersistantSettings pref,
  })  : _pref = pref,
        super(key: key);

  final SharedPersistantSettings _pref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _pref.isDarkMode
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                    Colors.deepPurple,
                    Colors.greenAccent,
                  ])
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                    Colors.yellow,
                    Colors.deepOrange,
                  ]),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: Icon(
                MaterialCommunityIcons.menu_down_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          Text(
            'AYaT PLAYER',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'MetalMania',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 25,
            ),
          ),
          IconButton(
              icon: Icon(
                MaterialCommunityIcons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              }),
        ],
      ),
    );
  }
}
