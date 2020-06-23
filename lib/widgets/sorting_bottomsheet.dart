import '../provider/audio_query.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortingBottomSheet extends StatelessWidget {
  final List title;
  final List sortType;
  final String list;

  SortingBottomSheet({this.sortType, this.title, this.list});
  @override
  Widget build(BuildContext context) {
    final _query = Provider.of<AudioQuery>(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: title.length,
        itemBuilder: (context, index) => ListTile(
          title:
              Text(title[index], maxLines: 1, style: Constants.kListTileTitle),
          leading: Icon(Icons.sort, color: Theme.of(context).accentColor),
          onTap: () {
            if (list == 'song') _query.getSongsInfo(sortType: sortType[index]);
            if (list == 'album')
              _query.getAllAlbumInfo(albumSortType: sortType[index]);
            if (list == 'artist')
              _query.getAllArtistInfo(artistSortType: sortType[index]);
            Navigator.of(context).pop(false);
          },
        ),
      ),
    );
  }
}

// children: <Widget>[
//       ListTile(
//           title: Text('Default'),
//           onTap: () {
//             _query.getSongsInfo(sortType: SongSortType.DEFAULT);
//             Navigator.of(context).pop(false);
//           }),
//       ListTile(
//           title: Text('ascending-album'),
//           onTap: () {
//             _query.getSongsInfo(sortType: SongSortType.ALPHABETIC_ALBUM);
//             Navigator.of(context).pop(false);
//           }),
//       ListTile(
//           title: Text('ascending-artist'),
//           onTap: () {
//             _query.getSongsInfo(sortType: SongSortType.ALPHABETIC_ARTIST);
//             Navigator.of(context).pop(false);
//           }),
//       ListTile(
//           title: Text('Greater duration'),
//           onTap: () {
//             _query.getSongsInfo(sortType: SongSortType.GREATER_DURATION);
//             Navigator.of(context).pop(false);
//           }),
//       ListTile(
//           title: Text('Recent year'),
//           onTap: () {
//             _query.getSongsInfo(sortType: SongSortType.RECENT_YEAR);
//             Navigator.of(context).pop(false);
//           }),
//     ],
//   );
