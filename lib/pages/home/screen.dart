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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.MAINBACKGROUNDCOLOR,
        child: Icon(Icons.refresh, color: Colors.white,),
        onPressed: () {
          homeController.printPermissionStatus();
          homeController.contacts.clear();
        },),
      backgroundColor: Constants.MAINBACKGROUNDCOLOR,
      body: SafeArea(
        child: Column(
          children: [
            TopPanel(),
            Padding(
              padding: EdgeInsets.only(top: 4.0, left: 12.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Your Contatcts".toUpperCase(),
                    style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 18.0)),
                  ),
                  IconButton(onPressed: (){
                    homeController.refreshingContacts.value = !homeController.refreshingContacts.value;
                  }, icon: Icon(Icons.upload, size: 28.0, color: Colors.white,),),
                ],
              ),
            ),
            BottomPanel()
          ],
        ),
      ),
    );
  }
}
