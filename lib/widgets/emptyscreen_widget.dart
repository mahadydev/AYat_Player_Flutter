import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: Image.asset(
          'assets/empty.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
