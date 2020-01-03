import 'package:flutter/material.dart';

Color statusBarColor = Color(0xFF20167c);
Color baseColor = Color(0xFF3369e7);
Color submitColor = Color(0xFF1DB954);
String permissionMessage =
    "SIST Admin needs phone state and location\npermissions to verify your register number and\n attendance, as requested by SIST. Please grant\n these permissions to proceed.";
var now = DateTime.now();

List<String> yearsList = now.month > 6
    ? [
        'Year',
        (now.year - 3).toString() + '-' + (now.year + 1).toString(),
        (now.year - 2).toString() + '-' + (now.year + 2).toString(),
        (now.year - 1).toString() + '-' + (now.year + 3).toString(),
        (now.year).toString() + '-' + (now.year + 4).toString()
      ]
    : [
        'Year',
        (now.year - 4).toString() + '-' + (now.year + 0).toString(),
        (now.year - 3).toString() + '-' + (now.year + 1).toString(),
        (now.year - 2).toString() + '-' + (now.year + 2).toString(),
        (now.year - 1).toString() + '-' + (now.year + 3).toString()
      ];

var sectionList = List<String>.generate(
    27, (i) => i == 0 ? 'Section' : String.fromCharCode(i + 64));

var deptList = ["Department", "CSE", "ECE", "IT", "EEE"];

String getInitials(String nameString) {
  if (nameString.isEmpty) return " ";

  List<String> nameArray =
      nameString.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");
  String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
      (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);

  return initials;
}
