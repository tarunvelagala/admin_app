import 'package:device_id/device_id.dart';

Future<String> getDeviceID() async {
  String devId = await DeviceId.getID;
  return devId;
}
