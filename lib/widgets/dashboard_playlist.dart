import '../provider/audio_query.dart';
import '../screens/playlist_to_songList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/constants.dart';

class DashBoardPlayList extends StatelessWidget {
  const DashBoardPlayList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioQuery>(
      builder: (context, AudioQuery _query, child) => Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.playlist_play,
                  color: Theme.of(context).accentColor,
                  size: 30,
                ),
                Text(
                  'PLAYLIST',
                  textAlign: TextAlign.start,
                  style: Constants.kListTileTitle,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    _query.getSongsFromPlayList(_query.playlist[index]);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayListSongs(
                          playlistIndex: index,
                          appBarTitle: _query.playlist[index].name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: _query.playlist[index].name != null
                        ? Center(
                            child: Text(
                              _query.playlist[index].name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'RobotoSlab',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Text('No Name'),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent])),
                  ),
                ),
                itemCount: _query.playlist.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
