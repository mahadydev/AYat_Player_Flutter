import 'package:provider/provider.dart';

import '../provider/audio_query.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePlayListDialog extends StatefulWidget {
  @override
  _CreatePlayListDialogState createState() => _CreatePlayListDialogState();
}

class _CreatePlayListDialogState extends State<CreatePlayListDialog> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AudioQuery _query = Provider.of<AudioQuery>(context);
    return AlertDialog(
      title: Text(
        'New Playlist'.toUpperCase(),
        textAlign: TextAlign.center,
        style: Constants.kAppBarTitleTextStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: "Playlist name",
              labelStyle: TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.done_outline,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                String _playlistname = _textEditingController.text;
                _playlistname.isNotEmpty
                    ? await _query.createNewPlayList(_playlistname)
                    : Fluttertoast.showToast(
                        msg: 'Enter a name!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 16.0);
                _textEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
