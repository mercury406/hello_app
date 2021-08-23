import 'dart:convert';

import 'package:covid_getx_app/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class BottomPanel extends GetView<HomeController> {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(
            () => Container(
              padding: EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
              width: Get.width,
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
              color: Constants.CONTAINERSBACKGROUNDCOLOR,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0))),
              child: homeController.contacts.length <= 0
                  ? Center(
                    child: homeController.openAppSettingsButtonEnabled.value
                        ? MaterialButton(onPressed: () {openAppSettings();}, textColor: Colors.white, child: Text("Open app settings"), color: Constants.MAINBACKGROUNDCOLOR,)
                        : homeController.refreshingContacts.value
                          ? CircularProgressIndicator(color: Colors.white,)
                          : Text("No contacts found", style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE).copyWith(fontSize: 22),),
                  )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemCount: homeController.contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            homeController.contacts[index]["name"],
                            style: GoogleFonts.roboto(
                                textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 22)),
                          ),
                          subtitle: Text(
                            homeController.contacts[index]["msisdn"],
                            style: GoogleFonts.roboto(
                                textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 14)),
                          ),
                          trailing: IconButton(
                            onPressed: () async{
                              if(homeController.awaitingHttpRequest.value){
                                Get.snackbar("Ошибка", "Уже отправляется", backgroundColor: Colors.red, colorText: Colors.white);
                              } else{
                                homeController.awaitingHttpRequest.value = true;
                                var httpBody = jsonEncode({"from": homeController.uid.value, "to": homeController.contacts[index]["msisdn"]});
                                await http.post(Uri.parse("${Constants.MAINURL}/notify"), body: httpBody, headers: {"Content-Type": "application/json"});
                                homeController.awaitingHttpRequest.value = false;
                              }
                            },
                            icon: Icon(Entypo.hand, color: Colors.white, size: 30.0,),
                          ),
                        );
                      },
                  )
            )
        )
    );
  }
}
