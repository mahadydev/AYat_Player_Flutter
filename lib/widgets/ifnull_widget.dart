import 'package:flutter/material.dart';

class IfNullWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  const IfNullWidget({
    this.icon,
    this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
