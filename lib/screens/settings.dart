import 'package:ayat_player_flutter_player/model/iap.dart';
import 'package:ayat_player_flutter_player/util/theme_constants.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/sharedpref.dart';
import '../screens/custom_radio.dart';
import '../util/constants.dart';
import '../widgets/myappIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../provider/audio_query.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/material_color_dialog.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  IAP _iap;

  @override
  void initState() {
    _iap = IAP()..initIAPs();
    super.initState();
  }

  @override
  void dispose() {
    _iap.endBillingConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Constants.kAppBarTitleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   Look and Feel',
                      style: TextStyle(
                        fontFamily: 'MetalMania',
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Dark Mode',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Switch to Dark/Light theme',
                        style: Constants.kListTileSubTitle,
                      ),
                      trailing: Consumer<ThemeConstants>(
                        builder: (context, ThemeConstants _pref, _) => Switch(
                          value: _pref.isDarkModeON,
                          onChanged: (value) {
                            _pref.toggleTheme(value);
                          },
                        ),
                      ),
                    ),
                    Divider(),
                    Consumer<ThemeConstants>(
                      builder: (context, ThemeConstants _pref, _) => ListTile(
                        onTap: () async {
                          openDialog(
                            "Accent Color picker",
                            MaterialColorPicker(
                              colors: accentColors,
                              selectedColor: Theme.of(context).accentColor,
                              onColorChange: (color) {
                                _pref.setAccentColor(color);
                              },
                              circleSize:
                                  MediaQuery.of(context).size.width * 0.15,
                              spacing: 10,
                            ),
                            context,
                          );
                        },
                        title: Text(
                          'Accent Color',
                          style: Constants.kListTileTitle,
                        ),
                        isThreeLine: true,
                        subtitle: Text(
                          'Switch to favorite accent color\nPlease note that some color requires you to change theme for better viewing experience with background and font color.',
                          style: Constants.kListTileSubTitle,
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: _pref.accentColor ??
                              Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Divider(),
                    Consumer<ThemeConstants>(
                      builder: (context, ThemeConstants _pref, _) => ListTile(
                        onTap: () {
                          _pref.setNavIconAndAppbarTextColor(
                              _pref.navbarAppvarColor == Colors.white
                                  ? Colors.black
                                  : Colors.white);
                        },
                        title: Text(
                          'Appbar Text Color & Navbar Icon Color',
                          style: Constants.kListTileTitle,
                        ),
                        isThreeLine: true,
                        subtitle: Text(
                          'Switch the color of navbar icon and appbar text to white or black to match the accent color and theme ',
                          style: Constants.kListTileSubTitle,
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: _pref.navbarAppvarColor ??
                              Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   Now Playing',
                      style: TextStyle(
                        fontFamily: 'MetalMania',
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        MaterialCommunityIcons.swap_vertical_circle_outline,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Now Playing Screen',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Switch Between Classic and Modern Now Playing Screen',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomRadio()));
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Volume Controls',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Show Volume Controls in the Now Playing Screen',
                        style: Constants.kListTileSubTitle,
                      ),
                      trailing: Consumer<SharedPersistantSettings>(
                        builder:
                            (context, SharedPersistantSettings _pref, child) =>
                                Switch(
                          value: _pref.volumeControl,
                          onChanged: (value) {
                            _pref.setVolumeControl(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   Personalize',
                      style: TextStyle(
                        fontFamily: 'MetalMania',
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Carousel Slider',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Carousel for the DashBoard Screen included beautiful music pictures from unsplash',
                        style: Constants.kListTileSubTitle,
                      ),
                      trailing: Consumer(
                        builder: (context, SharedPersistantSettings _pref, _) =>
                            Switch(
                          value: _pref.isCarousel,
                          onChanged: (value) {
                            _pref.setCarousel(value);
                          },
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Home Album Grid',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Enable for Circular . Disable for Card',
                        style: Constants.kListTileSubTitle,
                      ),
                      trailing: Consumer<SharedPersistantSettings>(
                        builder: (context, SharedPersistantSettings _pref, _) =>
                            Switch(
                                value: _pref.homeAlbumGrid,
                                onChanged: (value) {
                                  _pref.setHomeAlbumGrid(value);
                                }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   Other',
                      style: TextStyle(
                        fontFamily: 'MetalMania',
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                    Consumer(
                      builder: (context, SharedPersistantSettings _pref, _) =>
                          ListTile(
                        title: Text(
                          'Filter Song Duration',
                          style: Constants.kListTileTitle,
                        ),
                        subtitle: Consumer(
                          builder: (context, AudioQuery _query, _) => Slider(
                            value: _pref.filterSongSeconds.toDouble(),
                            min: 0,
                            max: 60,
                            onChanged: (value) {},
                            onChangeEnd: (value) async {
                              await _pref.setFilterSec(value.round());
                              await _query.getSongsInfo();
                            },
                            activeColor: Theme.of(context).accentColor,
                            inactiveColor: Theme.of(context).accentColor,
                          ),
                        ),
                        trailing: Text(
                            '${_pref.filterSongSeconds.round().toString()}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   About',
                      style: TextStyle(
                        fontFamily: 'MetalMania',
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        letterSpacing: 0.25,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.rate_review,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Rate The App',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Love this App? Let Us Know in the Google Play Store How We Can Make This App Even Better',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () {
                        LaunchReview.launch();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.card_giftcard,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Donate',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'App Development is Costly and Time Consuming ! If You Think I Deserve to Get Paid for My Hard Work,You Can Leave Some Money Here',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () async {
                        await _iap.consumeAllItems();
                        await _iap.getProducts();
                        if (_iap.items.length > 0) {
                          _iap.requestPurchase(_iap.items[0]);
                        } else
                          Fluttertoast.showToast(
                              msg: "Error getting product",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.bug_report,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Report Bug',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'An Unexpected Error Occured! Sorry That You Found This Bug. Clear App Data or Send Us Email',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () async {
                        final Email email = Email(
                          body: '',
                          subject: 'About AYaT Player : Issue/Bug/Improvement',
                          recipients: ['mahadydev@gmail.com'],
                        );
                        await FlutterEmailSender.send(email);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.share,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Share',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Sharing is Caring. If You like This App Dont Forget to Share With Your Friends!',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () {
                        Share.share(
                            'Check out AYaT Player ! A beautiful and complete Audio Player Application for Android.\n\nhttps://play.google.com/store/apps/details?id=com.mahadydev.ayat_player',
                            subject: 'AYaT Player\n\n');
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.question_answer,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'FAQ',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Frequently Asked Question',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () async {
                        if (await canLaunch(Constants.faqUrl)) {
                          await launch(Constants.faqUrl);
                        } else {
                          throw 'Could not launch ${Constants.faqUrl}';
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.info_outline,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Lisences',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'All the Lisences information',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () {
                        showAboutDialog(
                          applicationIcon: MyAppIcon(),
                          context: context,
                          applicationVersion: Constants.appVersion,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'View all the open source licenses here ... ',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialIcons.security,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'Read Our Privacy Policy',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () async {
                        if (await canLaunch(Constants.privacyPolicyUrl)) {
                          await launch(Constants.privacyPolicyUrl);
                        } else {
                          throw 'Could not launch ${Constants.privacyPolicyUrl}';
                        }
                      },
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Version ${Constants.appVersion}',
                          style: Constants.kListTileTitle,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        MaterialCommunityIcons.history,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'ChangeLog',
                        style: Constants.kListTileTitle,
                      ),
                      subtitle: Text(
                        'See whats new in this version',
                        style: Constants.kListTileSubTitle,
                      ),
                      onTap: () async {
                        if (await canLaunch(Constants.changeLog)) {
                          await launch(Constants.changeLog);
                        } else {
                          throw 'Could not launch ${Constants.changeLog}';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                if (await canLaunch(Constants.github)) {
                  await launch(Constants.github);
                } else {
                  throw 'Could not launch ${Constants.github}';
                }
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/me.jpg'),
              ),
              title: Text(
                'Mahady Hasan',
                style: Constants.kListTileTitle,
              ),
              subtitle: Text(
                'Design and Development',
                style: Constants.kListTileSubTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Made with ❤ in BD',
                style: Constants.kListTileTitle,
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
