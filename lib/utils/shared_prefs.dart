import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  saveAttnIdAndDevID(String attnId, String devID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(devID, attnId);
  }

  Future<String> getAttnId(String devId) async {
    final prefs = await SharedPreferences.getInstance();
    String attnId = prefs.getString(devId);
    return attnId;
  }
}
