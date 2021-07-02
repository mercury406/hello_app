import 'package:covid_getx_app/exports.dart';
import 'package:covid_getx_app/routes/app_pages.dart';
import 'package:covid_getx_app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class SplashScreen extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.MAINBACKGROUNDCOLOR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.5,
              height: Get.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset(
                "assets/final_logo.png"
              ),
            ),
            SizedBox(height: 16,),
            CircularProgressIndicator(color: Colors.white,),
            SizedBox(height: 16,),
            Builder(builder: (context) {
              LocalPreferences.getRegisterUid()
                  .then((value) {
                    if(value == null){
                      Get.offNamed(AppRoutes.REGISTER);
                    } else{
                      Get.offNamed(AppRoutes.HOME);
                    }
                  }
              );
              return Text("Loading", style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE),);
            },)
          ],
        ),
      ),
    );
  }

}