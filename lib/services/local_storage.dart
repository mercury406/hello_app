import 'package:covid_getx_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {

  static Future<String ?> getRegisterUid() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    String? uid = sPref.getString(StorageKeys.UID) ?? null;
    print("IsRegistered in SharedPreferences: $uid");
    return uid;
  }

  static Future<void> setRegisteredUid(String uid) async {
    await SharedPreferences.getInstance().then((SharedPreferences sPref) {
      sPref.setString(StorageKeys.UID, uid);
    });
  }

  static Future<void> singOut() async{
    await SharedPreferences.getInstance().then((SharedPreferences sPref) {
      sPref.remove(StorageKeys.UID);
    });
  }

}