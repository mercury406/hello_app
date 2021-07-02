import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeController extends GetxController{

  RxList contacts = [1, 2, 3].obs;
  RxBool refreshingContacts = true.obs;
  RxBool openAppSettingsButtonEnabled = false.obs;


  void printPermissionStatus() async{
    var status = await Permission.contacts.status;

    switch (status) {
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
        openAppSettingsButtonEnabled.value = true;
        print("Not granted");
        break;
      case PermissionStatus.granted:
        openAppSettingsButtonEnabled.value = false;
        print("Contacts ____");
        await getPhoneContacts();
        print("granted");
        break;
    }
  }

dynamic getPhoneContacts() async{
  Iterable<Contact> contacts = await ContactsService.getContacts();
  print(contacts);
}

void requestPermission() async{
    PermissionStatus status = await Permission.contacts.status;
    if(status != PermissionStatus.granted){
      await Permission.contacts.request();
    }
}

@override
  void onInit() {
    requestPermission();
    super.onInit();
  }

// Future<bool> checkContactRequestPermission() async{
//
// }

}