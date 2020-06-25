import 'dart:io';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class DashboardArtistList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.artist,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            Text(
              '  ARTIST',
              textAlign: TextAlign.start,
              style: Constants.kListTileTitle,
            ),
          ],
        ),
        Consumer<AudioQuery>(
          builder: (context, AudioQuery _query, child) => Container(
            margin: const EdgeInsets.only(top: 20),
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  _query.setCurrentArtistSelected(_query.artistList[index]);
                  Navigator.of(context).pushNamed('/songfromartist');
                },
                child: Hero(
                  tag: _query.artistList[index].artistArtPath,
                  child: ClipOval(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _query.artistList[index].artistArtPath != null
                              ? FileImage(
                                  File(_query.artistList[index].artistArtPath))
                              : AssetImage('assets/empty.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: _query.artistList.length ?? 0,
            ),
          ),
        ),
      ],
    );
  }
}
