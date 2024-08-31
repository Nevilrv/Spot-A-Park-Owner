import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';
import 'package:owner_app/utils/notification_service.dart';

class InformationScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;
  RxString countryCode = "+91".obs;

  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  RxList<String> genderList = ["Male", "Female", "Others"].obs;

  RxString profileImage = "".obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      ownerModel.value = argumentData['ownerModel'];
      loginType.value = ownerModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.value.text = ownerModel.value.phoneNumber.toString();
        countryCode.value = ownerModel.value.countryCode.toString();
      } else {
        emailController.value.text = ownerModel.value.email.toString();
        fullNameController.value.text = ownerModel.value.fullName.toString();
      }
    }
    update();
  }

  createAccount() async {
    String fcmToken = await NotificationService.getToken();
    if (profileImage.value.isNotEmpty) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }

    ShowToastDialog.showLoader("Please Wait..".tr);
    OwnerModel ownerModelData = ownerModel.value;
    ownerModelData.fullName = fullNameController.value.text;
    ownerModelData.email = emailController.value.text;
    ownerModelData.countryCode = countryCode.value;
    ownerModelData.phoneNumber = phoneNumberController.value.text;
    ownerModelData.profilePic = profileImage.value;
    ownerModelData.fcmToken = fcmToken;
    ownerModelData.createdAt = Timestamp.now();

    await FireStoreUtils.updateUser(ownerModelData).then((value) {
      ShowToastDialog.closeLoader();
      if (value == true) {
        Get.offNamed(Routes.DASHBOARD_SCREEN);
      }
    });
  }
}
