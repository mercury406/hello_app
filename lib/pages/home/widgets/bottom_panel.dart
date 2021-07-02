import 'package:covid_getx_app/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

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
                      itemCount: homeController.contacts.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            "Murat",
                            style: GoogleFonts.roboto(
                                textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 22)),
                          ),
                          subtitle: Text(
                            "+998901785020",
                            style: GoogleFonts.roboto(
                                textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 14)),
                          ),
                          trailing: Icon(
                            Entypo.hand,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        );
                      },
                  )
            )
        )
    );
  }
}
