import 'package:admin_app/screens/batch_details.dart';
import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/utils/crud_utils.dart';
import 'package:admin_app/utils/otp_utils.dart';
import 'package:admin_app/utils/request_permssions.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:countdown/countdown.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "Welcome Admin",
          onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => FaqScreen()))),
      body: Welcome(),
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  CrudUtils crudUtils = CrudUtils();
  String otp;
  OtpUtil otpUtil = OtpUtil();
  CountDown cd;
  var sub;
  String time = "1";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/tick-mark-512.png',
              height: 100.0,
              width: 100.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              child: Text("Register Students"),
              onPressed: () {
                checkForCameraPermissions();
              },
            ),
            RaisedButton(
              child: Text("Take Attendance"),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => BatchDetailsScreen()));
              },
            )
          ],
        ),
      ),
    );
  }

  checkForCameraPermissions() async {
    MyAwesomeStatus status = await PermissionHelper()
        .askLocationPermission(TargetPlatform.android, PermissionGroup.camera);
    if (status == MyAwesomeStatus.doNotAskAgain) {
      _showOpenSettingsModal(status);
    }
    if (status == MyAwesomeStatus.notGranted) {
      _showRequestPermissionModal(status);
    }
    if (status == MyAwesomeStatus.granted) {
      // s.saveAttnIdAndDevID(attnID, devID);
      /*Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => RegisterStudent()));*/
      final scaffold = Scaffold.of(context);
      String res = await scanner.scan();
      // print(res);
      /*if (await crudUtils.verifyStudentRegInDb(res) == true) {
        final snackbar = Scaffold.of(context);
        snackbar.showSnackBar(SnackBar(
          content: Text('Invalid Register Number'),
          backgroundColor: Colors.red,
        ));
      }*/
      var resList = res.split('\$');
      if (await crudUtils.verifyOnlyRegInDB(resList[0]) ||
          await crudUtils.verifyOnlyDevIdInDB(resList[5])) {
        scaffold.showSnackBar(SnackBar(
          content: Text(
            "Student already added.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        crudUtils.addStudentDetails(res);
        scaffold.showSnackBar(SnackBar(
          content: Text(
            "Student Added Successfully",
          ),
          backgroundColor: Colors.green,
        ));
      }
    }
  }

  _showOpenSettingsModal(MyAwesomeStatus status) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              onVerticalDragStart: (_) {},
              child: Container(
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Image.asset(
                      'assets/images/tick-mark-512.png',
                      height: 75.0,
                      width: 75.0,
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        permissionMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Divider(
                      color: Colors.black26,
                    ),
                    MaterialButton(
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "open settings".toUpperCase(),
                            style: TextStyle(
                                color: baseColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await PermissionHandler().openAppSettings();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showRequestPermissionModal(MyAwesomeStatus status) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              onVerticalDragStart: (_) {},
              child: Container(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Image.asset(
                        'assets/images/tick-mark-512.png',
                        height: 75.0,
                        width: 75.0,
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          permissionMessage,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Divider(
                        color: Colors.black26,
                      ),
                      MaterialButton(
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "allow permissions".toUpperCase(),
                              style: TextStyle(
                                  color: baseColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (status == MyAwesomeStatus.notGranted) {
                            status = await PermissionHelper()
                                .askLocationPermission(TargetPlatform.android,
                                    PermissionGroup.camera);
                          }
                          if (status == MyAwesomeStatus.granted) {
                            // s.saveAttnIdAndDevID(attnID, devID);
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        WelcomeScreen()));
                          }
                          if (status == MyAwesomeStatus.doNotAskAgain) {
                            Navigator.of(context).pop();
                            _showOpenSettingsModal(status);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
