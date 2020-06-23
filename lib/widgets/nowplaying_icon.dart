import 'package:flutter/material.dart';

class NowPlayingIcon extends StatelessWidget {
  final Icon icon;

  final double height;
  final Function ontap;
  const NowPlayingIcon({
    this.height,
    this.icon,
    this.ontap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: ontap,
        child: Center(child: icon),
      ),
    );
  }
}
