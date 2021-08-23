import 'package:flutter/material.dart';

abstract class Constants{
  static const CONTAINERSBACKGROUNDCOLOR = Colors.blue;
  static const MAINBACKGROUNDCOLOR = Color(0xFF1565C0);
  static const MAINURL = "http://192.168.0.63:9000/api";
  static const DEFAULTEXTSTYLE = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  // TextStyle simpleStyle = TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Times New Roman");
  // TextStyle titleStyle = TextStyle(fontSize: 36.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Times New Roman");
  // TextStyle heading1 = TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Times New Roman");
  // TextStyle nameTextStyle = TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Times New Roman");
  // Color bgColor = Colors.blue[800];
  // Color containerBg = Colors.blue;
}

abstract class StorageKeys {
  static const UID = "uid";
  static const FCM = "fcm";
  static const CONTACTS_SENT = "contacts_sent";
  static const NOTIFICATION_COUNT = "notification_count";
}