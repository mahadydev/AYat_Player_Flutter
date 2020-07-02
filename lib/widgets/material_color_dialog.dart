import 'package:flutter/material.dart';

void openDialog(String title, Widget content, BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        title: Text('Material Accents'),
        content: Container(
          child: content,
          height: MediaQuery.of(context).size.height * 0.40,
          width: MediaQuery.of(context).size.width * 0.60,
        ),
      );
    },
  );
}
