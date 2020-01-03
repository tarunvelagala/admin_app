import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/screens/welcome_screen.dart';
import 'package:admin_app/services/crud_services.dart';
import 'package:admin_app/utils/constants.dart';
import 'package:admin_app/utils/crud_utils.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbsenteeScreen extends StatelessWidget {
  final String batch, section, department;
  AbsenteeScreen(
      {Key key,
      @required this.batch,
      @required this.section,
      @required this.department})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Absentees",
        onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => FaqScreen())),
      ),
      body: Absentee(
        batch: batch,
        section: section,
        department: department,
      ),
    );
  }
}

class Absentee extends StatefulWidget {
  final String batch, section, department;
  Absentee(
      {Key key,
      @required this.batch,
      @required this.section,
      @required this.department})
      : super(key: key);
  @override
  _AbsenteeState createState() => _AbsenteeState();
}

class _AbsenteeState extends State<Absentee> {
  bool selected = false;
  bool isMultipleSelection = false;
  var userStatus;
  var l;
  Future<List> getAbsenteeList() async {
    l = await CrudMethods().getStudentAttendanceVerified(
        // Student Absentee list firestore => get
        widget.section,
        widget.batch,
        widget.department);
    userStatus = List<bool>.filled(l.length, false);
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              elevation: 1,
              child: ListTile(
                title: Text(
                  "Select all".toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.select_all,
                    color: baseColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Expanded(
              child: absenteeList(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // print(_AbsenteeListState().getPresentStudents());
                    for (int i = 0; i < l.length; i++) {
                      // TODO: update true -> variable
                      CrudUtils().updateAttendanceInDb(l[i], true);
                    }
                    // TODO : Show Alert Dialog of attendance taken.
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext context) => WelcomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    height: 50.0,
                    color: baseColor,
                    child: Center(
                      child: Text(
                        "data".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget absenteeList() {
    return FutureBuilder(
      future: getAbsenteeList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: baseColor,
                  child: Text(
                    getInitials(snapshot.data[index]["student_name"]),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(snapshot.data[index]["student_name"]),
                subtitle: Text(snapshot.data[index]["reg_no"]),
                trailing: Checkbox(
                  value: userStatus[index],
                  onChanged: (bool value) {
                    //onCategorySelected(value);
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
