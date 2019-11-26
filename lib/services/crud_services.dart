import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  addAttnIDAndLocationAndDevId(adminData) {
    Firestore.instance
        .collection("admins")
        .add(adminData)
        .catchError((e) => print(e));
  }

  updateLocationOfAdmin(selectedDoc, newValue) async {
    Firestore.instance
        .collection('admins')
        .document(selectedDoc)
        .updateData(newValue)
        .catchError((e) => print(e));
  }

  addStudentsInDb(studentData) {
    Firestore.instance
        .collection("students")
        .add(studentData)
        .catchError((e) => print(e));
  }

  getAdminDetailsInDb(String attnId) {
    return Firestore.instance
        .collection('admins')
        .where('attendance_id', isEqualTo: attnId)
        .getDocuments();
  }

  /*getStudentRegDetails(String regNo) {
    return Firestore.instance
        .collection('students')
        .where('reg_no', isEqualTo: regNo)
        .getDocuments();
  }*/
  getStudentDeviceDetails(String devId, String regNo) {
    return Firestore.instance
        .collection('students')
        .where('reg_no', isEqualTo: regNo)
        .where('device_id', isEqualTo: devId)
        .getDocuments();
  }
  getStudentRegNumber(String regNo) {
    return Firestore.instance
        .collection("students")
        .where("reg_no", isEqualTo: regNo)
        .getDocuments();
  }

  getStudentDeviceId(String devId) {
    return Firestore.instance
        .collection("students")
        .where("device_id", isEqualTo: devId)
        .getDocuments();
  }
}
