import 'package:admin_app/services/crud_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class CrudUtils {
  CrudMethods crudObj = CrudMethods();
  Geoflutterfire geo = Geoflutterfire();
  addAdminDetails(_attnId, _devId, _location) {
    GeoFirePoint point =
        geo.point(latitude: _location.latitude, longitude: _location.longitude);
    var adminData = {
      'attendance_id': _attnId,
      'device_id': _devId,
      'location': point.data,
      'otp': "0",
      "batch": "",
      "section": "",
      "dept": "",
      "radius": "0",
    };
    crudObj.addAttnIDAndLocationAndDevId(adminData);
  }

  updateLocationOfAdmin(docs, _location) {
    GeoFirePoint point =
        geo.point(latitude: _location.latitude, longitude: _location.longitude);
    crudObj.updateLocationOfAdmin(
        docs.documents[0].documentID, {'location': point.data});
  }

  addStudentDetails(resString) {
    var l = resString.split('\$');
    print(l);
    GeoFirePoint point =
        geo.point(latitude: double.parse(l[6]), longitude: double.parse(l[7]));
    var studentData = {
      'reg_no': l[0],
      'student_name': l[1],
      'batch': l[2],
      'section': l[3],
      'dept': l[4],
      'device_id': l[5],
      'location': point.data,
      "attendance": [],
      "is_verified": "0"
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

  /*Future<bool> verifyStudentRegInDb(String resString) async {
    var regNo = resString.split('\$');
    bool isRegInDB = false;
    await crudObj
        .getStudentDeviceDetails(regNo[5].toString(), regNo[0].toString())
        .then((QuerySnapshot docs) {
      if (docs.documents.isEmpty) {
        isRegInDB = true;
        // addStudentDetails(resString);
      }
    });
    return isRegInDB;
  }*/

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

  storeOtpInDb(String otp, String attnId, bool timeStarted) {
    // bool isVerified = false;
    crudObj.getAdminDetailsInDb(attnId).then((QuerySnapshot docs) {
      if (timeStarted) {
        crudObj.updateOtp(docs.documents[0].documentID, {'otp': otp});
      } else {
        crudObj.makeOtpZero(docs.documents[0].documentID, {'otp': '0'});
      }
      //isVerified = true;
    });
  }

  storeBatchDetailsInDb(
      String attnId, String batch, String section, String dept, String radius) {
    crudObj.getAdminDetailsInDb(attnId).then((QuerySnapshot docs) {
      crudObj.updateBatchDetails(docs.documents[0].documentID,
          {'batch': batch, 'section': section, 'dept': dept, "radius": radius});
    });
  }

  updateAttendanceInDb(DocumentSnapshot docs, bool status) {
    var date = DateTime.now();
    crudObj.updateAttendanceArray(docs.documentID, {
      "is_verified": status ? "1" : "0",
      "attendance": FieldValue.arrayUnion([
        {
          "${date.year}-${date.month}-${date.day}": status ? "1" : "0",
        }
      ])
    });
  }
}
