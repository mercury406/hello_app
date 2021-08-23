import 'package:covid_getx_app/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LocalPreferences {

  static Future<int> getNotificationCount() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    return sPref.getInt(StorageKeys.NOTIFICATION_COUNT) ?? 0;
  }

  static Future<void> setNotificationCount(int value) async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    sPref.setInt(StorageKeys.NOTIFICATION_COUNT, value);
  }

  static Future<void> remove(String key) async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    sPref.remove(key);
  }

  static Future<int> incNotificationCount() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    int notificationCount = sPref.containsKey(StorageKeys.CONTACTS_SENT)
      ? (sPref.getInt(StorageKeys.NOTIFICATION_COUNT) ?? 0)
      : 0;
    // print("IncNotificationCount fun value: $notificationCount");

    setNotificationCount(notificationCount + 1);
    return notificationCount + 1 ;
  }

  static Future<String ?> getRegisterUid() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    String? uid = sPref.getString(StorageKeys.UID);
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

  static Future<void> checkAndSaveToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    if(token != null){
      await SharedPreferences.getInstance().then((SharedPreferences sPref) async{
        String? savedToken = sPref.getString(StorageKeys.FCM);
        var localUid = await getRegisterUid();
        if(localUid != null ) {
          http.post(Uri.parse("${Constants.MAINURL}/savefcm"), body: {"uid": localUid, "fcm": token});
        }
        if(savedToken != null && savedToken != token){
          sPref.setString(StorageKeys.FCM, token);
        }
      });
    }
  }

  static Future<bool?> isContactsSent () async{
    SharedPreferences.getInstance().then((SharedPreferences sPref) {
      return sPref.getBool(StorageKeys.CONTACTS_SENT) ?? false;
    });
  }

  static Future<void> setContactsSent () async{
    SharedPreferences.getInstance().then((SharedPreferences sPref) {
      return sPref.setBool(StorageKeys.CONTACTS_SENT, true);
    });
  }

  // static Future<void> sendContacts() async {
  //   await SharedPreferences.getInstance().then((SharedPreferences sPref) async{
  //
  //   }
  // }
}