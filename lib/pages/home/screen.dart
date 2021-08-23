import 'package:covid_getx_app/pages/home/widgets/bottom_panel.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => !homeController.floatingRefreshBtnEnabled.value ? Container() :
          FloatingActionButton(
          backgroundColor: Constants.MAINBACKGROUNDCOLOR,
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () async {
            homeController.floatingRefreshBtnEnabled.value = false;
            homeController.contacts.clear();
            await homeController.getNearby();
            homeController.floatingRefreshBtnEnabled.value = true;
          },
        ),
      ),
      backgroundColor: Constants.MAINBACKGROUNDCOLOR,
      body: SafeArea(
        child: Column(
          children: [
            TopPanel(),
            Padding(
              padding: EdgeInsets.only(top: 4.0, left: 12.0, right: 16.0),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Your Contatcts".toUpperCase(),
                      style: GoogleFonts.roboto(
                          textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 18.0)),
                    ),
                    !homeController.uploadBtnEnabled.value
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            height: 24,
                            width: 24,
                          )
                        : IconButton(
                            onPressed: () async {
                              homeController.contacts.clear();
                              homeController.uploadBtnEnabled.value = false;
                              homeController.refreshingContacts.value =
                                  !homeController.refreshingContacts.value;
                              var contactsMap = await homeController.getPhoneContacts();
                              await homeController.sendContactsToServer(contactsMap);
                              homeController.uploadBtnEnabled.value = true;
                            },
                            icon: Icon(
                              Icons.upload,
                              size: 28.0,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            BottomPanel()
          ],
        ),
      ),
    );
  }
}
