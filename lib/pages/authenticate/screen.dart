import 'package:google_fonts/google_fonts.dart';

import '../../exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.MAINBACKGROUNDCOLOR,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  width: Get.width * 0.5,
                  height: Get.width * 0.5,
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(200)),
                  child: Image.asset("assets/final_logo.png",)
              ),
              Text("Welcome to", style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 24.0)),),
              Text("COVID HELLO", style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 28.0)),),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Constants.CONTAINERSBACKGROUNDCOLOR,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                height: Get.width * 0.7,
                width: Get.width,
                child: Column(
                  children: [
                    Text("Registration", style: GoogleFonts.roboto(textStyle: Constants.DEFAULTEXTSTYLE.copyWith(fontSize: 24.0)),),
                    RegistrationForm(),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0,),
        Obx(
            () => TextFormField(
              onChanged: (msisdn) {
                authController.phoneNumber.value = msisdn;
              },
                autofocus: true,
                enabled: authController.isPhoneInputEnabled.value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: authController.isPhoneInputEnabled.value ? Colors.white: Colors.grey[400],
                  filled: true,
                  hintText: "Enter phone number",
                  contentPadding: EdgeInsets.fromLTRB(16.0, 10, 10, 10),
                  prefix: Text("+"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                )
            )
        ),
        Obx(
            () => Visibility(
              visible: !authController.isCodeInputVisible.value,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: authController.isPhoneButtonEnabled.value
                    ? customMaterialButton(authController.phoneEnteredButtonPressed, "send sms")
                    : CircularProgressIndicator(color: Colors.white,)
              ),
            )
        ),
        Obx(
          () => Visibility(
            visible: authController.isCodeInputVisible.value,
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (code) {
                    authController.confirmationCode.value = code;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter confirmation code",
                    contentPadding: EdgeInsets.fromLTRB(16.0, 10, 10, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  )
              ),
            ),
          ),
        ),
        Obx(
            () => Visibility(
              visible: authController.isCodeInputVisible.value,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: authController.isCodeButtonEnabled.value
                  ? customMaterialButton(authController.codeEnteredButtonPressed, "Register")
                  : CircularProgressIndicator(color: Colors.white,),
              )
            )
        )
      ],
    );
  }

  Widget customMaterialButton(Function pressKeyFunc, String text){
    return MaterialButton(
      onPressed: () {pressKeyFunc();}, child: Text(text.toUpperCase()),
      color: Constants.MAINBACKGROUNDCOLOR,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.white, width: 1.0)
      ),
      splashColor: Colors.white,
    );
  }
}