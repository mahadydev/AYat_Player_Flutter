import 'dart:io';

import '../provider/audio_query.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../provider/audio_player.dart';

class YourNextFavoriteList extends StatelessWidget {
  const YourNextFavoriteList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              FontAwesome.music,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            Text(
              '  YOUR NEXT FAVORITE',
              textAlign: TextAlign.start,
              style: Constants.kListTileTitle,
            ),
          ],
        ),
        Consumer<AudioQuery>(
          builder: (context, AudioQuery _query, _) => Container(
            margin: const EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 0.20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Consumer<AudioPlayer>(
                builder: (context, AudioPlayer _player, _) => GestureDetector(
                  onTap: () {
                    _player.initPlaylistSounds(_query.randomSongList, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: _query.randomSongList[index].albumArtwork != null
                            ? Image.file(
                                File(_query.randomSongList[index].albumArtwork),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/empty.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: _query.randomSongList.length ?? 0,
            ),
          ),
        ),
      ],
    );
  }
}
