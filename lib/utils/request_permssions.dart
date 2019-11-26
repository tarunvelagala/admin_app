import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MyAwesomeStatus { granted, notGranted, doNotAskAgain }

class PermissionHelper {
  Future<MyAwesomeStatus> askLocationPermission(
      TargetPlatform platform, PermissionGroup permissionGroup) async {
    MyAwesomeStatus status;
    if (platform == TargetPlatform.android) {
      Map<PermissionGroup, PermissionStatus> permissionsGranted =
          await PermissionHandler().requestPermissions([permissionGroup]);
      PermissionStatus permissionStatus = permissionsGranted[permissionGroup];

      if (permissionStatus == PermissionStatus.granted) {
        status = MyAwesomeStatus.granted;
      } else {
        bool beenAsked = await hasPermissionBeenAsked(permissionGroup);
        bool rationale = await PermissionHandler()
            .shouldShowRequestPermissionRationale(permissionGroup);
        if (beenAsked && !rationale) {
          status = MyAwesomeStatus.doNotAskAgain;
        } else {
          status = MyAwesomeStatus.notGranted;
        }
      }
    } else {
      status = MyAwesomeStatus.granted;
    }

    setPermissionHasBeenAsked(permissionGroup);
    return status;
  }

  Future<void> setPermissionHasBeenAsked(
      PermissionGroup permissionGroup) async {
    (await SharedPreferences.getInstance())
        .setBool('PERMISSION_ASKED_${permissionGroup.value}', true);
  }

  Future<bool> hasPermissionBeenAsked(PermissionGroup permissionGroup) async {
    return (await SharedPreferences.getInstance())
            .getBool('PERMISSION_ASKED_${permissionGroup.value}') ??
        false;
  }
}
