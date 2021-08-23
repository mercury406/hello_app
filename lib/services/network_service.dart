import 'dart:convert';

import 'package:covid_getx_app/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NetworkService extends GetConnect{
  void sendLocation(String Uid, Position position) {
    var httpBody = jsonEncode({
      "uid": Uid,
      "long": position.longitude,
      "lat": position.latitude
    });
    Future<Response> httpResponse = post("${Constants.MAINURL}/location", httpBody);

    print("Location sent with code: " + httpResponse.toString());

  }
}