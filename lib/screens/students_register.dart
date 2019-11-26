import 'package:admin_app/screens/faqs.dart';
import 'package:admin_app/utils/crud_utils.dart';
import 'package:admin_app/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'SIST Admin',
        onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => FaqScreen())),
      ),
      body: RegisterStudent(),
    );
  }
}

class RegisterStudent extends StatefulWidget {
  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  CrudUtils crudUtils = CrudUtils();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text("Scan"),
          onPressed: () async {
            //String resString = await scanner.scan();
            //crudUtils.verifyStudentInDb(resString);
          },
        ),
      ),
    );
  }
}
