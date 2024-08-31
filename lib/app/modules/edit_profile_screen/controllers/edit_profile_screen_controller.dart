import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class EditProfileScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;

  RxString countryCode = "".obs;
  RxBool isLoading = false.obs;

  RxList<String> genderList = ["Male", "Female", "Others"].obs;
  RxString selectedGender = "Male".obs;
  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getProfileData();
    super.onInit();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        ownerModel.value = value;
        fullNameController.value.text = ownerModel.value.fullName!;
        emailController.value.text = ownerModel.value.email!;
        countryCode.value = ownerModel.value.countryCode!;
        phoneNumberController.value.text = ownerModel.value.phoneNumber!;

        profileImage.value = ownerModel.value.profilePic!;
        isLoading.value = true;
      }
    });
  }

  updateProfile() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    if (profileImage.value.isNotEmpty && Constant.hasValidUrl(profileImage.value) == false) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }
    OwnerModel ownerModelData = ownerModel.value;
    ownerModelData.fullName = fullNameController.value.text;
    ownerModelData.email = emailController.value.text;
    ownerModelData.countryCode = countryCode.value;
    ownerModelData.phoneNumber = phoneNumberController.value.text;
    ownerModelData.profilePic = profileImage.value;

    await FireStoreUtils.updateUser(ownerModelData).then((value) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Profile updated");
    });
  }

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }
}
