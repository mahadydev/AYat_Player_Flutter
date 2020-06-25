import 'dart:io';

import '../data/sharedpref.dart';
import '../provider/audio_query.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class DashBoardAlbumList extends StatelessWidget {
  const DashBoardAlbumList({
    Key key,
    @required SharedPersistantSettings pref,
  })  : _pref = pref,
        super(key: key);

  final SharedPersistantSettings _pref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.album,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            Text(
              '  ALBUM',
              textAlign: TextAlign.start,
              style: Constants.kListTileTitle,
            ),
          ],
        ),
        Consumer<AudioQuery>(
          builder: (context, AudioQuery _query, child) => Container(
            margin: const EdgeInsets.only(top: 20),
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Center(
                child: _pref.homeAlbumGrid
                    ? Hero(
                        tag: _query.albumList[index].albumArt,
                        child: ClipOval(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 175,
                            width: 175,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _query.albumList[index].albumArt != null
                                    ? FileImage(
                                        File(_query.albumList[index].albumArt))
                                    : AssetImage('assets/empty.png'),
                              ),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _query
                              .setCurrentAlbumSelected(_query.albumList[index]);
                          Navigator.of(context).pushNamed('/songfromalbum');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: Container(
                              height: 175,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: _query.albumList[index].albumArt != null
                                  ? Hero(
                                      tag: _query.albumList[index].albumArt,
                                      child: Image.file(
                                          File(
                                              _query.albumList[index].albumArt),
                                          fit: BoxFit.cover),
                                    )
                                  : Image.asset(('assets/empty.png'),
                                      fit: BoxFit.cover),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              itemCount: _query.albumList.length ?? 0,
            ),
          ),
        ),
      ],
    );
  }
}
