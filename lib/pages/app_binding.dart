import 'package:covid_getx_app/services/local_storage.dart';
import 'package:get/get.dart';
import '../../exports.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LocalPreferences>(() => LocalPreferences());
  }

}