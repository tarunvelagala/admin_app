import 'package:admin_app/services/crud_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudUtils {
  CrudMethods crudObj = CrudMethods();
  addAdminDetails(_attnId, _devId, _location) {
    var adminData = {
      'attendance_id': _attnId,
      'device_id': _devId,
      'location': GeoPoint(_location.latitude, _location.longitude),
    };
    crudObj.addAttnIDAndLocationAndDevId(adminData);
  }

  updateLocationOfAdmin(docs, _location) {
    crudObj.updateLocationOfAdmin(docs.documents[0].documentID,
        {'location': GeoPoint(_location.latitude, _location.longitude)});
  }

  addStudentDetails(resString) {
    var l = resString.split('\$');
    print(l);
    var studentData = {
      'reg_no': l[0],
      'student_name': l[1],
      'batch': l[2],
      'section': l[3],
      'dept': l[4],
      'device_id': l[5]
    };
    crudObj.addStudentsInDb(studentData);
  }

  verifyAdminInDb(_attnId, _devId, _location) {
    try {
      crudObj.getAdminDetailsInDb(_attnId).then((QuerySnapshot docs) {
        if (docs.documents.isEmpty || docs.documents == null) {
          addAdminDetails(_attnId, _devId, _location);
        } else {
          updateLocationOfAdmin(docs, _location);
        }
      });

      // print(v);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> verifyStudentRegInDb(String resString) async {
    var regNo = resString.split('\$');
    bool isAlreadyInDB = false;
    await crudObj
        .getStudentDeviceDetails(regNo[5].toString(), regNo[0].toString())
        .then((QuerySnapshot docs) {
      if (docs.documents.isEmpty) {
        isAlreadyInDB = true;
        addStudentDetails(resString);
      }
    });
    return isAlreadyInDB;
  }

  Future<bool> verifyOnlyRegInDB(String regNo) async {
    bool isverified = false;
    await crudObj.getStudentRegNumber(regNo).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        isverified = true;
      }
    });
    print("reg no in db" + isverified.toString());
    return isverified;
  }

  Future<bool> verifyOnlyDevIdInDB(String devId) async {
    bool isverified = false;
    await crudObj.getStudentDeviceId(devId).then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        isverified = true;
      }
    });
    print("dev no in db" + isverified.toString());
    return isverified;
  }
}
