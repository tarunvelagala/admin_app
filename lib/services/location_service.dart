import 'package:geolocator/geolocator.dart';

Future<Position> getLocation() async {
  var locator = Geolocator();
  var currLocation = await locator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      locationPermissionLevel: GeolocationPermission.locationAlways);
  return currLocation;
}
