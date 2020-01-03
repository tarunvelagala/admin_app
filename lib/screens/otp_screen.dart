import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/utils/shared_prefs.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  final String otp;
  OtpScreen({Key key, @required this.otp}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "Take Attendance",
          onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => FaqScreen()))),
      body: Otp(
        otp: otp,
      ),
    );
  }
}

class Otp extends StatefulWidget {
  final String otp;
  Otp({Key key, @required this.otp}) : super(key: key);
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  CountDown cd;
  var sub;
  String time = "1";
  String attnId;
  SharedPrefs sharedPrefs = SharedPrefs();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    cd = CountDown(Duration(minutes: 1));
    sub = cd.stream.listen(null);
    sub.onData((Duration duration) {
      setState(() {
        time =
            "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
      });
    });

    sub.onDone(() {
      setState(() {
        time = "done";
      });

      sub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: 350.0,
          height: 100.0,
          child: Text(widget.otp),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: 350.0,
          height: 100.0,
          child: Text(time),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ));
  }
}
