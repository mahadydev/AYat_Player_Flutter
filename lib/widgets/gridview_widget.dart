import 'dart:io';
import 'package:flutter/material.dart';

class GridTileWidget extends StatelessWidget {
  final String title;
  final String sub;
  final String imagePath;
  GridTileWidget({
    this.title,
    this.imagePath,
    this.sub,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
            title: Text(
              title,
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).backgroundColor),
            ),
            subtitle: Text(
              sub,
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).backgroundColor),
            ),
          ),
          child: imagePath != null
              ? Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/empty.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
