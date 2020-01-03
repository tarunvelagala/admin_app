// import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<DocumentSnapshot> snapshotMarksList = List<DocumentSnapshot>();

Future<Position> getLocation() async {
  var locator = Geolocator();
  //var cl = Location();
  //var cll = await cl.getLocation();
  var currLocation = await locator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      locationPermissionLevel: GeolocationPermission.locationAlways);
  return currLocation;
  // return cll;
}

calculateRadius(Position location, String radius) async {
  print(location.latitude);
  print(double.parse(radius) / 10.0);
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  GeoFirePoint center =
      geo.point(latitude: location.latitude, longitude: location.longitude);
  var collectionReference = _firestore.collection('students');
  var geoRef = geo.collection(collectionRef: collectionReference);
  var stream = geoRef.within(
      center: center,
      radius: double.parse(radius) / 10.0,
      field: 'location',
      strictMode: true);
  var l = stream.firstWhere((test) => test.isNotEmpty);
  var x = await l;
  for (var i in x) {
    print(i.data);
  }
  // print(snapshotMarksList);
}
