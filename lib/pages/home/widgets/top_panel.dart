import 'package:covid_getx_app/exports.dart';
import 'package:covid_getx_app/routes/app_pages.dart';
import 'package:covid_getx_app/services/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TopPanel extends GetView<HomeController>{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, left: 12.0),
      width: Get.width,
      height: Get.height * 0.3,
      decoration: BoxDecoration(
        color: Constants.CONTAINERSBACKGROUNDCOLOR,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COVID HELLO",
                style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE).copyWith(fontSize: 40.0),
              ),
              IconButton(
                  onPressed: () {print("hello");},
                  icon: Icon(Icons.settings, color: Colors.white, size: 32.0,)
              ),
              IconButton(
                  onPressed: () {
                    LocalPreferences.singOut();
                    AuthController authController = Get.find();
                    authController.firebaseSignOut();
                    authController.setDefaults();
                    Get.offNamed(AppRoutes.SPLASH);
                  },
                  icon: Icon(Icons.exit_to_app, color: Colors.white, size: 32.0,)
              )
            ],
          )
        ],
      ),
    );
  }
}