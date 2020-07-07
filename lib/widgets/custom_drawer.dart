import 'dart:io';

import '../data/sharedpref.dart';
import '../util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);

    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey.withAlpha(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _pref.photo.isEmpty || _pref.photo == null
                    ? Image.asset(
                        "assets/empty.png",
                        width: 100,
                        height: 100,
                      )
                    : ClipOval(
                        child: Image.file(
                          File(_pref.photo),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _pref.nickname.toUpperCase(),
                  style: Constants.kListTileTitle,
                ),
                Text(
                  _pref.email.toLowerCase(),
                  style: Constants.kListTileSubTitle,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
              closeDrawer();
            },
            leading: Icon(
              MaterialCommunityIcons.face_profile,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Profile"),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
              closeDrawer();
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Settings"),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/equalizer');
              closeDrawer();
            },
            leading: Icon(
              Icons.equalizer,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Equalizer"),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            onTap: () {
              SystemNavigator.pop();
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Exit"),
          ),
        ],
      ),
    );
  }
}
