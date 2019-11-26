import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/screens/welcome_screen.dart';
import 'package:admin_app/services/location_service.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/utils/crud_utils.dart';
import 'package:admin_app/utils/device_utils.dart';
import 'package:admin_app/utils/request_permssions.dart';
import 'package:admin_app/utils/shared_prefs.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Register Admin',
        onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => FaqScreen())),
      ),
      body: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPrefs s = SharedPrefs();
  CrudUtils crudUtils = CrudUtils();
  String attnID;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    "Register",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Please enter your Attendance ID",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: baseColor,
                        ),
                        child: TextFormField(
                          cursorColor: baseColor,
                          inputFormatters: [
                            BlacklistingTextInputFormatter(
                                new RegExp(r'[.,-\s@#$%(&_;?/"*!-]')),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty)
                              return '';
                            else if (value.length < 4)
                              return 'Please enter a valid attendance ID';
                            else
                              return null;
                          },
                          onSaved: (value) {
                            attnID = value;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular((10.0)),
                              ),
                              labelText: 'Attendance ID',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                size: 30.0,
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    //String devID = await DeviceId.getID;
                    //s.saveAttnIdAndDevID(_attnID, devID);
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      checkForLocationPermissions();
                    }
                  },
                  child: Container(
                    color: baseColor,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Register".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  checkForLocationPermissions() async {
    String devID = await getDeviceID();
    MyAwesomeStatus status = await PermissionHelper().askLocationPermission(
        TargetPlatform.android, PermissionGroup.locationAlways);
    ServiceStatus serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    if (serviceStatus == ServiceStatus.disabled ||
        serviceStatus == ServiceStatus.unknown) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(SnackBar(
        content: Text("Please enable device location"),
      ));
    } else {
      if (status == MyAwesomeStatus.doNotAskAgain) {
        _showOpenSettingsModal(status);
      }
      if (status == MyAwesomeStatus.notGranted) {
        _showRequestPermissionModal(status, devID);
      }
      if (status == MyAwesomeStatus.granted) {
        s.saveAttnIdAndDevID(attnID, devID);
        var _location = await getLocation();
        crudUtils.verifyAdminInDb(attnID, devID, _location);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (BuildContext context) => WelcomeScreen()));
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

  _showRequestPermissionModal(MyAwesomeStatus status, String devID) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
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
                                    PermissionGroup.location);
                          }
                          if (status == MyAwesomeStatus.granted) {
                            s.saveAttnIdAndDevID(attnID, devID);
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
