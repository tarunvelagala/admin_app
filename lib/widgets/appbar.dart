import 'package:admin_app/utils/constants.dart';
import 'package:flutter/material.dart';

Widget appBar({String title, Function onPressed}) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: baseColor,
    title: Text(title),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.help_outline),
        onPressed: onPressed,
      ),
    ],
  );
}
