import 'dart:convert';
import 'package:covid_getx_app/routes/app_pages.dart';
import 'package:covid_getx_app/services/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../exports.dart';

class AuthController extends GetxController {
  GlobalKey<FormState>? regFormKey;
  RxBool isPhoneInputEnabled = true.obs;
  RxBool isPhoneButtonEnabled = true.obs;
  RxBool isCodeInputVisible = false.obs;
  RxBool isCodeButtonEnabled = true.obs;
  RxString phoneNumber = "".obs;
  RxString confirmationCode = "".obs;
  RxBool registrationSuccess = false.obs;

  void setDefaults() {
    this.isPhoneInputEnabled.value = true;
    this.isPhoneButtonEnabled.value = true;
    this.isCodeInputVisible.value = false;
    this.isCodeButtonEnabled.value = true;
    this.phoneNumber.value = "";
    this.confirmationCode.value = "";
  }

  void phoneEntered() {
    this.isPhoneInputEnabled.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    regFormKey = GlobalKey<FormState>();
  }

  // Send number to provide confirmation code to this number
  void phoneEnteredButtonPressed() async {
    String number = this.phoneNumber.value;
    this.isPhoneButtonEnabled.value = false;
    if (checkPhoneNumberValidity(number)) {
      http.Response response = await this.sendPhoneToServer();
      if (response.statusCode == 200) {
        this.phoneEntered();
        this.isCodeInputVisible.value = true;
        this.isCodeButtonEnabled.value = true;
      } else {
        print(response.body);
        var decoded = json.decode(response.body);
        errorSnack(decoded["message"]);
        this.isPhoneButtonEnabled.value = true;
      }
    } else {
      errorSnack("Number must be numeric");
      this.isPhoneButtonEnabled.value = true;
    }
  }

  // Sending code to register user
  void codeEnteredButtonPressed() async {
    this.isCodeButtonEnabled.value = false;
    if (checkConfCodeValidity(this.confirmationCode.value)) {
      http.Response response = await this.sendCodeToServer();
      if (response.statusCode == 200) {
        var decodeBody = json.decode(response.body);
        var regId = decodeBody["registration"];
        firebaseRegistration(regId);
      } else {
        var decodeBody = json.decode(response.body);
        errorSnack(decodeBody["message"]);
        this.isCodeButtonEnabled.value = true;
      }
    } else {
      errorSnack("Code must be numeric");
      this.isCodeButtonEnabled.value = true;
    }
  }

  bool checkPhoneNumberValidity(String phoneNumber) {
    return this.isNumeric(phoneNumber);
  }

  bool checkConfCodeValidity(String code) {
    return this.isNumeric(code);
  }

  Future<dynamic> sendPhoneToServer() async {
    return await http
        .post(Uri.parse("${Constants.MAINURL}/get-code"), body: {"phone": this.phoneNumber.value});
  }

  Future<dynamic> sendCodeToServer() async {
    return await http.post(Uri.parse("${Constants.MAINURL}/register"),
        body: {"phone": this.phoneNumber.value, "code": this.confirmationCode.value});
  }

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void errorSnack(String message) {
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[900],
        colorText: Colors.white);
  }

  void firebaseRegistration(var id) async {
    FirebaseAuthService authService = FirebaseAuthService();
    User? user = await authService.signInAnon();
    try {
      if (user != null) {
        await LocalPreferences.setRegisteredUid(user.uid);
        LocalPreferences.getRegisterUid().then((status) => print("LocalPrefs regStatus: $status") );
        await http.post(Uri.parse("${Constants.MAINURL}/register/$id"), body: {"uid": user.uid});
        Get.snackbar("success", "Registered");
        this.registrationSuccess.value = true;
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        errorSnack("Can't register. Try another time");
        this.isCodeButtonEnabled.value = true;
      }
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  void firebaseSignOut () {
    FirebaseAuthService authService = FirebaseAuthService();
    authService.signOut();
  }

}
