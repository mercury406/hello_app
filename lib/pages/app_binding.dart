import 'package:covid_getx_app/services/local_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../exports.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<FlutterLocalNotificationsPlugin>(FlutterLocalNotificationsPlugin());
    Get.put<HomeController>(HomeController());
    Get.put<AuthController>(AuthController());
    Get.put<LocalPreferences>(LocalPreferences());
  }

}