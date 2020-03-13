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
  var l;
  // List<String> _absenteeList = List();
  bool isMultipleSelection = false;
  bool isSelectButtonSelected = false, isAllSelected = false;
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  Future<List> getAbsenteeList() async {
    l = await CrudMethods().getStudentAttendanceVerified(
        // Student Absentee list firestore => get
        widget.section,
        widget.batch,
        widget.department);
    /*l.forEach((f) {
      _absenteeList.add(f["reg_no"]);
    });*/
    return l;
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  checkIfAllSelected(x) {
    if (_selectedIndexList.length == x.length) {
      return true;
    }
    return false;
  }

  addListIndex() {
    for (int i = 0; i < l.length; i++) {
      if (!_selectedIndexList.contains(i)) {
        _selectedIndexList.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _selectionMode
                ? Material(
                    elevation: 1,
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            isSelectButtonSelected = !isSelectButtonSelected;
                          });
                          if (isSelectButtonSelected) {
                            addListIndex();
                          } else {
                            if (checkIfAllSelected(l)) {
                              _selectedIndexList.clear();
                            } else {
                              addListIndex();
                              isSelectButtonSelected = !isSelectButtonSelected;
                            }
                          }
                        },
                        title: Text(
                          "Select all".toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        leading: Icon(
                          Icons.info_outline,
                          color: baseColor,
                        ),
                        trailing: Icon(
                          isSelectButtonSelected && checkIfAllSelected(l)
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelectButtonSelected && checkIfAllSelected(l)
                              ? baseColor
                              : null,
                        )),
                  )
                : Material(
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: baseColor,
                      ),
                      title: Text("Long press for multiple selection"),
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
                      CrudUtils().updateAttendanceInDb(
                          l[i], _selectedIndexList.contains(i));
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

  FutureBuilder absenteeList() {
    return FutureBuilder(
      future: getAbsenteeList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (_selectionMode) {
                return ListTile(
                  onLongPress: () {
                    setState(() {
                      _changeSelection(enable: false, index: -1);
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (_selectedIndexList.contains(index)) {
                        _selectedIndexList.remove(index);
                      } else {
                        _selectedIndexList.add(index);
                      }
                      if (_selectedIndexList.isEmpty) {
                        _changeSelection(enable: false, index: -1);
                      }
                      if (_selectedIndexList.length == snapshot.data.length) {
                        isAllSelected = !isAllSelected;
                      }
                      if (!checkIfAllSelected(snapshot.data)) {
                        isSelectButtonSelected = true;
                      }
                    });
                    print(_selectedIndexList);
                  },
                  leading: CircleAvatar(
                    backgroundColor: baseColor,
                    child: Text(
                      getInitials(snapshot.data[index]["student_name"]),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(snapshot.data[index]["student_name"]),
                  subtitle: Text(snapshot.data[index]["reg_no"]),
                  trailing: Icon(
                    _selectedIndexList.contains(index)
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color:
                        _selectedIndexList.contains(index) ? baseColor : null,
                  ),
                );
              } else {
                return ListTile(
                  leading: CircleAvatar(
                    child:
                        Text(getInitials(snapshot.data[index]["student_name"])),
                  ),
                  subtitle: Text(snapshot.data[index]["reg_no"]),
                  title: Text(snapshot.data[index]["student_name"]
                      .toString()
                      .toUpperCase()),
                  onLongPress: () {
                    setState(() {
                      _changeSelection(enable: true, index: index);
                    });
                  },
                );
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
