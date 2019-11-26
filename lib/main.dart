import 'package:admin_app/screens/register_screen.dart';
import 'package:admin_app/screens/welcome_screen.dart';
import 'package:admin_app/services/crud_services.dart';
import 'package:admin_app/utils/device_utils.dart';
import 'package:admin_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MaterialApp(title: 'SIST Admin', home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CrudMethods crudObj = CrudMethods();
  SharedPrefs s = SharedPrefs();

  startTime() async {
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() async {
    final String devId = await getDeviceID();
    var attnId = await s.getAttnId(devId);
    if (attnId != null) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => WelcomeScreen()));
    }
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => RegisterScreen()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/tick-mark-512.png',
            height: 150,
            width: 150,
          )
        ],
      ),
    );
  }
}
