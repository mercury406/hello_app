import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import './exports.dart';
import './routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  initServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.native,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
      transitionDuration: Duration(milliseconds: 230),
      initialRoute: AppPages.INITIAL,
      initialBinding: MainBinding(),
      getPages: AppPages.routes,
    );
  }
}

void initServices() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}