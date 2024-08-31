import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/models/watchman_model.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class AddWatchmanScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> dateOfBirthController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> salaryController = TextEditingController().obs;

  RxString countryCode = "+91".obs;
  RxBool isLoading = true.obs;

  Rx<ParkingModel> selectedParkingModel = ParkingModel().obs;
  RxList<ParkingModel> parkingList = <ParkingModel>[].obs;

  Rx<WatchManModel> watchManModel = WatchManModel().obs;

  @override
  void onInit() {
    getParkingList();
    super.onInit();
  }

  getArguments() async {
    isLoading.value = true;
    dynamic argument = Get.arguments;
    if (argument != null) {
      watchManModel.value = argument['watchManModel'];
      await FireStoreUtils.getWatchmanDetail(watchManModel.value.id.toString()).then((value) async {
        if (value != null) {
          watchManModel.value = value;
          salaryController.value.text = watchManModel.value.salary!;
          nameController.value.text = watchManModel.value.name!;
          emailController.value.text = watchManModel.value.email!;
          dateOfBirthController.value.text = watchManModel.value.dateOfBirth!;
          phoneNumberController.value.text = watchManModel.value.phoneNumber!;
          countryCode.value = watchManModel.value.countryCode!;
          int index = parkingList.indexWhere((element) => element.id == watchManModel.value.parkingId);
          if (index != -1) {
            selectedParkingModel.value = parkingList[index];
          }
        }
      });
    }
    isLoading.value = false;
  }

  getParkingList() async {
    await FireStoreUtils.getMyParkingList().then((value) {
      if (value != null) {
        parkingList.value = value;
        if (parkingList.isNotEmpty) {
          selectedParkingModel.value = parkingList.first;
        }
      }
    });
    getArguments();
  }

  Future<UserCredential?> signUpEmailWithPass(email, password) async {
    try {
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      return await FirebaseAuth.instanceFor(app: secondaryApp).createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      ShowToastDialog.showToast("This Email is already exists ");
      ShowToastDialog.closeLoader();
    }
    return null;
  }

  saveWatchManDetail() async {
    if (formKey.value.currentState!.validate()) {
      if (watchManModel.value.id == null) {
        ShowToastDialog.showLoader("please wait");
        String email = emailController.value.text.toLowerCase();
        String password = "${Constant.getRandomNumber()}";


        if (selectedParkingModel.value.id == null) {
          ShowToastDialog.showToast("Please Select Parking");
          return;
        }

        await signUpEmailWithPass(email, password).then((value) async {
          watchManModel.value.id = value!.user!.uid;
          watchManModel.value.ownerId = FireStoreUtils.getCurrentUid();
          watchManModel.value.parkingId = selectedParkingModel.value.id;
          watchManModel.value.phoneNumber = phoneNumberController.value.text;
          watchManModel.value.name = nameController.value.text;
          watchManModel.value.salary = salaryController.value.text;
          watchManModel.value.countryCode = countryCode.value;
          watchManModel.value.active = true;
          watchManModel.value.dateOfBirth = dateOfBirthController.value.text;
          watchManModel.value.createdAt = Timestamp.now();
          watchManModel.value.email = email;
          watchManModel.value.password = password;

          await FireStoreUtils.updateWatchManProfile(watchManModel.value).whenComplete(() async {
            await emailSend(email, password);
            Get.back(result: true);
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("WatchMen Created Successful");
          });
        }).catchError((error) {
          //ShowToastDialog.showToast("$error");
          ShowToastDialog.closeLoader();
          log("Error : $error");
        });
      } else {
        watchManModel.value.parkingId = selectedParkingModel.value.id;
        watchManModel.value.name = nameController.value.text;
        watchManModel.value.salary = salaryController.value.text;
        watchManModel.value.countryCode = countryCode.value;
        watchManModel.value.phoneNumber = phoneNumberController.value.text;
        watchManModel.value.dateOfBirth = dateOfBirthController.value.text;
        await FireStoreUtils.updateWatchManProfile(watchManModel.value).whenComplete(() async {
          Get.back(result: true);
          ShowToastDialog.closeLoader();
          ShowToastDialog.showToast("WatchMen Information Update");
        });
      }
    }
  }

  emailSend(String email, String password) async {
    final Email emailSend = Email(
      body: 'Your Watchman App Login \nEmail :- $email\n Password :- $password',
      subject: 'Your login information',
      recipients: [email],
      isHTML: false,
    );

    await FlutterEmailSender.send(emailSend);
  }
}
