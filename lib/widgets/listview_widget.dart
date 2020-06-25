import 'dart:io';
import '../util/constants.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final String sub;
  final String imagePath;
  ListTileWidget({this.title, this.imagePath, this.sub});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Constants.kListTileTitle),
      subtitle: Text(sub, style: Constants.kListTileSubTitle),
      leading: Hero(
        tag: imagePath,
        child: CircleAvatar(
          backgroundImage: imagePath != null
              ? FileImage(File(imagePath))
              : AssetImage('assets/empty.png'),
        ),
      ),
    );
  }
}
