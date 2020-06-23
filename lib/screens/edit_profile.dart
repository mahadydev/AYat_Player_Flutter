import 'dart:io';

import '../data/sharedpref.dart';
import '../util/constants.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //File _image;
  final picker = ImagePicker();
  TextEditingController _nameController;
  TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    super.initState();
  }

  Future getImage(SharedPersistantSettings p) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print(pickedFile.path);
    p.setImage(pickedFile.path);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _pref = Provider.of<SharedPersistantSettings>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          'PROFILE',
                          style: TextStyle(
                            fontFamily: 'Merryweather',
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child:
                                      _pref.photo.isEmpty || _pref.photo == null
                                          ? Image.asset(
                                              'assets/empty.png',
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(File(_pref.photo)),
                                ),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  getImage(_pref);
                                },
                                icon: Icon(
                                  Icons.file_upload,
                                  color: Theme.of(context).accentColor,
                                ),
                                label: Text(
                                  'Upload Photo',
                                  style: Constants.kAppBarTitleTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: size.width / 6),
                  height: 60,
                  width: size.width,
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'Nick Name',
                      labelStyle: TextStyle(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: size.width / 6),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'E-mail',
                      labelStyle: TextStyle(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: size.width / 6, top: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[300],
                          blurRadius:
                              10.0, // has the effect of softening the shadow
                          spreadRadius:
                              1.0, // has the effect of extending the shadow
                          offset: Offset(
                            5.0, // horizontal, move right 10
                            5.0, // vertical, move down 10
                          ),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: FlatButton(
                    onPressed: () {
                      String name = _nameController.text;
                      String email = _emailController.text;
                      if (name.isNotEmpty && email.isNotEmpty) {
                        _pref.setNickEmail(email, name);
                        Navigator.of(context).pop(false);
                      } else {
                        print('check');
                        showDialog(
                          context: context,
                          child: FancyDialog(
                            title: 'Error',
                            descreption: 'Please Enter Valid Information',
                            animationType: FancyAnimation.BOTTOM_TOP,
                            gifPath: FancyGif.FUNNY_MAN,
                            theme: FancyTheme.FANCY,
                            cancel: 'Now Now',
                            cancelFun: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
