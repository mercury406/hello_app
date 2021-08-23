import 'package:covid_getx_app/services/NotificationService.dart';
import 'package:covid_getx_app/services/local_storage.dart';
import 'package:covid_getx_app/services/network_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';

import './exports.dart';
import './routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



Future<void> main() async {
  initServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(MyApp()));
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask("2", "Positioning", frequency: Duration(minutes: 15));

  getPosition();

}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData){
    print(DateTime.now().toString() + ":> "+ taskName);
    getPosition();
    return Future.value(true);
  });
}

void getPosition () async {
  var position = await _determinePosition();
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    FlutterLocalNotificationsPlugin fltNotification = Get.put(FlutterLocalNotificationsPlugin());
    return GetMaterialApp(
      enableLog: false,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
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

Future<void> backgroundMessageHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();

  NotificationService notificationService = NotificationService();

  notificationService.showNotification(msg);

}

Future<Location?> _determinePosition() async {
  print("position");

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  location.enableBackgroundMode(enable: true);

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
  print("Current location: " + _locationData.longitude.toString() + " _ " + _locationData.longitude.toString());
  // bool serviceEnabled;
  // LocationPermission permission;
  //
  // // Test if location services are enabled.
  // serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   // Location services are not enabled don't continue
  //   // accessing the position and request users of the
  //   // App to enable the location services.
  //   return Future.error('Location services are disabled.');
  // }
  //
  // permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     // Permissions are denied, next time you could try
  //     // requesting permissions again (this is also where
  //     // Android's shouldShowRequestPermissionRationale
  //     // returned true. According to Android guidelines
  //     // your App should show an explanatory UI now.
  //     return Future.error('Location permissions are denied');
  //   }
  // }
  //
  // if (permission == LocationPermission.deniedForever) {
  //   // Permissions are denied forever, handle appropriately.
  //   return Future.error(
  //       'Location permissions are permanently denied, we cannot request permissions.');
  // }
  //
  // // When we reach here, permissions are granted and we can
  // // continue accessing the position of the device.
  // var currentPosition = await Geolocator.getCurrentPosition();
  // debugPrint("Position ====> $currentPosition");
  //
  // NetworkService networkService = NetworkService();
  // String? uid = await LocalPreferences.getRegisterUid();
  // if(uid != null){
  //   print(uid);
  //   networkService.sendLocation(uid, currentPosition);
  // }
  //
  // return currentPosition;
}