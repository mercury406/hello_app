import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:covid_getx_app/constants.dart';
import 'package:covid_getx_app/services/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxList contacts = [].obs;
  RxBool refreshingContacts = true.obs;
  RxBool openAppSettingsButtonEnabled = false.obs;
  RxString uid = "".obs;
  RxBool uploadBtnEnabled = true.obs;
  RxBool floatingRefreshBtnEnabled = true.obs;
  RxBool awaitingHttpRequest = false.obs;



  FlutterLocalNotificationsPlugin fltNotification = Get.find();

  void initialContactsGet() async {
    bool isContactsSent = await LocalPreferences.isContactsSent() ?? false;
    if (!isContactsSent) {
      var perm = await Permission.contacts.isGranted;
      if(perm){
        var cs = getPhoneContacts();
        sendContactsToServer(cs);
        LocalPreferences.setContactsSent();
      } else{
        return;
      }
    } else {
      getNearby();
    }
  }

  void checkPermissionStatus() async {
    var status = await Permission.contacts.status;
    switch (status) {
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
        openAppSettingsButtonEnabled.value = true;
        break;
      case PermissionStatus.granted:
        openAppSettingsButtonEnabled.value = false;
        break;
    }
  }

  dynamic getPhoneContacts() async {
    if (await Permission.contacts.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Map<String, String?>> contactsMap = [];
      for (Contact contact in contacts) {
        if (contact.phones != null &&
            contact.phones!.length > 0 &&
            contact.phones!.first.value!.startsWith("+")) {
          var c = {"name": contact.displayName, "msisdn": contact.phones!.first.value};
          contactsMap.add(c);
        }
      }
      return contactsMap.length > 0 ? contactsMap : null;
    } else{
      openAppSettingsButtonEnabled.value = true;
      return null;
    }
  }

  dynamic sendContactsToServer(contactsMap) async {
    this.refreshingContacts.value = true;
    var isGranted = await Permission.contacts.isGranted;
    // print("isGranted _______ $isGranted");
    if (isGranted) {
      contactsMap = await contactsMap;
      if(contactsMap != null){
        var httpBody = jsonEncode({"uid": this.uid.value, "contacts": contactsMap});
        http.Response response = await http.post(Uri.parse("${Constants.MAINURL}/contacts"),
            body: httpBody, headers: {"Content-Type": "application/json"});
        setContacts(response.body);
      } else{
        setContacts(null);
      }
    } else {
      openAppSettingsButtonEnabled.value = true;
    }
    this.refreshingContacts.value = false;
  }

  dynamic getNearby() async {
    this.refreshingContacts.value = true;
    var httpBody = jsonEncode({"uid": this.uid.value});
    http.Response responseFromServer = await http.post(Uri.parse("${Constants.MAINURL}/nearby"),
        body: httpBody, headers: {"Content-Type": "application/json"});
    setContacts(responseFromServer.body);
    this.refreshingContacts.value = false;
  }

  void setContacts(responseBody) {
    if(responseBody == null){
      this.contacts.value = [];
      this.refreshingContacts.value = false;
      return;
    }

    var decodedResponse = jsonDecode(responseBody);
    if (decodedResponse["status"] == "ok") {
      var serverContacts = [];
      for (var c in decodedResponse["contacts"])
        serverContacts.add({"name": c["name"], "msisdn": c["msisdn"]});
      this.contacts.value = serverContacts;
      this.refreshingContacts.value = false;
    }
    if (this.contacts.length == 0) this.refreshingContacts.value = false;
  }

  void requestPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    var afterRequestStatus;
    if (status != PermissionStatus.granted) {
      afterRequestStatus = await Permission.contacts.request();
      if (afterRequestStatus == PermissionStatus.granted) {
        this.openAppSettingsButtonEnabled.value = false;
      }
    }
    initialContactsGet();
  }

  void loadUId() async {
    this.uid.value = (await LocalPreferences.getRegisterUid())!;
  }

  Future<void> firebaseInitAndMessageHandler() async {
    await Firebase.initializeApp();

    LocalPreferences.setNotificationCount(0);
    fltNotification.cancelAll();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    fltNotification.initialize(initializationSettings);

    FirebaseMessaging.instance.getToken().then((token) => print("FCM TOKEN: $token"));

    // FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
    //   if(initialMessage != null){
    //     var notification = initialMessage.notification;
    //     if(notification != null){
    //       var title = notification.title;
    //       print("INITIAL MESSAGE: $title");
    //     }
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print("on message: ${msg.notification!.title}");
      // showNotification(msg);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      print("on message opened app: ${msg.notification!.title}");
      LocalPreferences.setNotificationCount(0);
      fltNotification.cancelAll();
    });

    LocalPreferences.checkAndSaveToken();
  }


  @override
  void onInit() {
    loadUId();
    this.requestPermission();
    checkPermissionStatus();
    firebaseInitAndMessageHandler();
    super.onInit();
  }

}