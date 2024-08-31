import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_app/app/modules/edit_profile_screen/controllers/edit_profile_screen_controller.dart';
import 'package:owner_app/app/widget/mobile_number_textfield.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:owner_app/themes/screen_size.dart';

class EditProfileScreenView extends GetView<EditProfileScreenController> {
  const EditProfileScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<EditProfileScreenController>(
        init: EditProfileScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(backgroundColor: AppColors.white, context, "Edit Profile".tr, isBack: true),
              body: controller.isLoading.value
                  ? SingleChildScrollView(
                      child: Form(
                        key: controller.formKey.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  buildBottomSheet(context, controller);
                                },
                                child: Center(
                                  child: SizedBox(
                                    height: Responsive.width(30, context),
                                    width: Responsive.width(30, context),
                                    child: Stack(
                                      children: [
                                        controller.profileImage.isEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(60),
                                                child: Image.asset(
                                                  Constant.userPlaceHolder,
                                                  height: Responsive.width(30, context),
                                                  width: Responsive.width(30, context),
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : (Constant.hasValidUrl(controller.profileImage.value))
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(60),
                                                    child: NetworkImageWidget(
                                                      imageUrl: controller.profileImage.value,
                                                      height: Responsive.width(30, context),
                                                      width: Responsive.width(30, context),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(60),
                                                    child: Image.file(
                                                      File(controller.profileImage.value),
                                                      height: Responsive.width(30, context),
                                                      width: Responsive.width(30, context),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                        Positioned(right: 0, bottom: 0, child: SvgPicture.asset("assets/icons/ic_camera.svg")),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFieldWidgetPrefix(
                                titleFontSize: 16,
                                titleFontFamily: AppThemData.semiBold,
                                titleColor: AppColors.darkGrey10,
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_user.svg",
                                  ),
                                ),
                                title: "Full Name".tr,
                                hintText: "Enter Full Name".tr,
                                controller: controller.fullNameController.value,
                                onPress: () {},
                              ),
                              TextFieldWidgetPrefix(
                                titleFontSize: 16,
                                titleFontFamily: AppThemData.semiBold,
                                titleColor: AppColors.darkGrey10,
                                prefix: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_email.svg",
                                  ),
                                ),
                                title: "Email".tr,
                                hintText: "Enter Email Address".tr,
                                controller: controller.emailController.value,
                                validator: (value) => Constant.validateEmail(value),
                                onPress: () {},
                              ),
                              MobileNumberTextField(
                                titleFontSize: 16,
                                titleFontFamily: AppThemData.semiBold,
                                titleColor: AppColors.darkGrey10,
                                title: "Mobile Number".tr,
                                controller: controller.phoneNumberController.value,
                                countryCode: controller.countryCode.value,
                                onPress: () {},
                              ),
                              const SizedBox(
                                height: 33,
                              ),
                              ButtonThem.buildButton(
                                btnHeight: 56,
                                txtSize: 16,
                                context,
                                title: "Save".tr,
                                txtColor: AppColors.lightGrey01,
                                bgColor: AppColors.darkGrey10,
                                onPress: () {
                                  if (controller.formKey.value.currentState!.validate()) {
                                    controller.updateProfile();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Constant.loader());
        });
  }
}

buildBottomSheet(BuildContext context, EditProfileScreenController controller) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: Responsive.height(22, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text("Please Select".tr, style: const TextStyle(fontSize: 16, fontFamily: AppThemData.medium)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.camera),
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "Camera".tr,
                              style: const TextStyle(fontFamily: AppThemData.medium),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.gallery),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "Gallery".tr,
                              style: const TextStyle(fontFamily: AppThemData.medium),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
