import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_app/app/widget/mobile_number_textfield.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/screen_size.dart';

import '../controllers/information_screen_controller.dart';

class InformationScreenView extends GetView<InformationScreenController> {
  const InformationScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset("assets/icons/ic_arrow_left.svg")),
        ),
        backgroundColor: AppColors.lightGrey02,
      ),
      body: Form(
        key: controller.formKey.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Complete Your Profile",
                        style: TextStyle(
                            fontFamily: AppThemData.semiBold,
                            fontSize: 20,
                            color: AppColors.darkGrey10),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        "Provide your essential details and add a profile picture to personalize your experience",
                        style: TextStyle(
                            fontFamily: AppThemData.regular,
                            color: AppColors.lightGrey10),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                      Center(
                        child: Container(
                          height: Responsive.width(30, context),
                          width: Responsive.width(30, context),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: GestureDetector(
                            onTap: () {
                              buildBottomSheet(context, controller);
                            },
                            child: Obx(
                              () => controller.profileImage.value.isEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.asset(
                                        Constant.userPlaceHolder,
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_user.svg",
                          ),
                        ),
                        title: "Full Name",
                        hintText: "Enter Full Name",
                        controller: controller.fullNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        prefix: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_email.svg",
                          ),
                        ),
                        title: "Email",
                        hintText: "Enter Email Address",
                        controller: controller.emailController.value,
                        validator: (value) => Constant.validateEmail(value),
                        onPress: () {},
                      ),
                      MobileNumberTextField(
                        title: "Mobile Number".tr,
                        controller: controller.phoneNumberController.value,
                        countryCode: controller.countryCode.value,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: !keyboardIsOpen,
                  child: ButtonThem.buildButton(
                    btnHeight: 56,
                    txtSize: 16,
                    context,
                    title: "Save and Continue",
                    txtColor: AppColors.lightGrey01,
                    bgColor: AppColors.darkGrey10,
                    onPress: () {
                      if (controller.formKey.value.currentState!.validate()) {
                        controller.createAccount();
                      }
                    },
                  )),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }

  buildBottomSheet(
      BuildContext context, InformationScreenController controller) {
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
                    child: Text("please_select".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemData.semiBold,
                        )),
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
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.camera),
                                icon: const Icon(Icons.camera_alt, size: 32)),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("camera".tr),
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
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("gallery".tr),
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
}
