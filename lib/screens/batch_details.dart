import 'package:admin_app/screens/absentees_screen.dart';
import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/utils/crud_utils.dart';
import 'package:admin_app/utils/otp_utils.dart';
import 'package:admin_app/utils/shared_prefs.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';

class BatchDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "Welcome Admin",
          onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => FaqScreen()))),
      body: BatchDetails(),
    );
  }
}

class BatchDetails extends StatefulWidget {
  @override
  _BatchDetailsState createState() => _BatchDetailsState();
}

class _BatchDetailsState extends State<BatchDetails> {
  String selectedYear = '', studentName;
  String currentSelectedYear = yearsList[0];
  String currentSelectedSection = sectionList[0];
  String currentSelectedDepartment = deptList[0];
  String radius;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CrudUtils crudUtils = CrudUtils();
  String otp;
  OtpUtil otpUtil = OtpUtil();
  CountDown cd;
  var sub;
  String attnId;
  String time = "1";
  bool timeStarted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Register",
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Please fill in your details",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: baseColor,
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            items: yearsList.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                this.currentSelectedYear = value;
                              });
                            },
                            validator: (val) {
                              if (val != 'Year') {
                                return null;
                              }
                              return 'Please select a year';
                            },
                            value: currentSelectedYear,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: baseColor,
                          ),
                          child: DropdownButtonFormField(
                            hint: Text('Please select the batch'),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                prefixIcon: Icon(Icons.sort_by_alpha),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            items: sectionList.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            validator: (val) {
                              if (val != 'Section') {
                                return null;
                              }
                              return 'Please select a section.';
                            },
                            onChanged: (String value) {
                              setState(() {
                                this.currentSelectedSection = value;
                              });
                            },
                            value: currentSelectedSection,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: baseColor,
                          ),
                          child: DropdownButtonFormField(
                            hint: Text('Please select the department'),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                prefixIcon: Icon(Icons.sort_by_alpha),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            items: deptList.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            validator: (val) {
                              if (val != 'Department') {
                                return null;
                              }
                              return 'Please select a department.';
                            },
                            onChanged: (String value) {
                              setState(() {
                                this.currentSelectedDepartment = value;
                              });
                            },
                            value: currentSelectedDepartment,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: baseColor,
                          ),
                          child: TextFormField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            cursorColor: baseColor,
                            inputFormatters: [
                              BlacklistingTextInputFormatter(
                                  new RegExp(r'[.,-\s]')),
                              LengthLimitingTextInputFormatter(1),
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Radius should not be empty.';
                              } else if (value == '0') {
                                return 'Radius should not be empty.';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (radius_1) {
                              radius = radius_1;
                            },
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.location_searching, size: 30.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: "Radius (1-9)",
                            ),
                          ),
                        )
                      ],
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
                onTap: () {
                  //String devID = await DeviceId.getID;
                  //s.saveAttnIdAndDevID(_attnID, devID);
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    crudUtils.storeBatchDetailsInDb(
                        attnId,
                        currentSelectedYear,
                        currentSelectedSection,
                        currentSelectedDepartment,
                        radius);
                    // TODO:  Change timer value
                    cd = CountDown(Duration(seconds: 5));
                    sub = cd.stream.listen(null);
                    otp = otpUtil.getRandomOtp();
                    print(otp);
                    startTimer(radius);
                  }
                },
                child: Container(
                  color: baseColor,
                  width: double.infinity,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      "Get Otp".toUpperCase(),
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
    );
  }

  _showOtpModal(String otp) {
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
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/tick-mark-512.png',
                        height: 75.0,
                        width: 75.0,
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Here is your One Time Password",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "to validate attendance",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          otp,
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                      Text(
                        "valid for only two minutes.",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    sub.onDone(() {
      timeStarted = false;
      crudUtils.storeOtpInDb(otp, attnId, timeStarted);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => AbsenteeScreen(
                batch: currentSelectedYear,
                department: currentSelectedDepartment,
                section: currentSelectedSection,
              )));
    });
  }

  startTimer(String radius) async {
    String deviceId = await DeviceId.getID;
    // var location = await getLocation();
    // calculateRadius(location, radius);
    attnId = await SharedPrefs().getAttnId(deviceId);
    timeStarted = true;
    crudUtils.storeOtpInDb(otp, attnId, timeStarted);
    _showOtpModal(otp);
    sub.onData((Duration duration) {
      //print(duration);
    });
  }
}
