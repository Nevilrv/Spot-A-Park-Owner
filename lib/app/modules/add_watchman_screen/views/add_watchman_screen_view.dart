import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/widget/mobile_number_textfield.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';
import '../../../../themes/button_theme.dart';
import '../controllers/add_watchman_screen_controller.dart';

class AddWatchmanScreenView extends StatelessWidget {
  const AddWatchmanScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GetX<AddWatchmanScreenController>(
        init: AddWatchmanScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(
                context,
                controller.isLoading.value
                    ? ""
                    : controller.watchManModel.value.id != null
                        ? "Edit WatchMen".tr
                        : "Add WatchMen".tr,
                backgroundColor: AppColors.lightGrey02),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: controller.formKey.value,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Parking".tr,
                                    style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  DropdownButtonFormField<ParkingModel>(
                                      isExpanded: false,
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(color: Colors.red),
                                        isDense: true,
                                        filled: true,
                                        fillColor: AppColors.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SvgPicture.asset("assets/icons/ic_car.svg", height: 24, width: 24),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: const BorderSide(color: AppColors.white, width: 1),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: const BorderSide(color: AppColors.white, width: 1),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: const BorderSide(color: AppColors.white, width: 1),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: const BorderSide(color: AppColors.white, width: 1),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: const BorderSide(color: AppColors.white, width: 1),
                                        ),
                                      ),
                                      value:
                                          controller.selectedParkingModel.value.id == null ? null : controller.selectedParkingModel.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.selectedParkingModel.value = value;
                                        } else {
                                          ShowToastDialog.showToast("Please create a parking".tr);
                                        }
                                      },
                                      style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.regular),
                                      hint: Text(
                                        "Select Your Parking".tr,
                                        style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.regular),
                                      ),
                                      items: controller.parkingList.map((item) {
                                        return DropdownMenuItem<ParkingModel>(
                                          value: item,
                                          child: Text(item.parkingName.toString(),
                                              style: const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.regular)),
                                        );
                                      }).toList()),
                                  TextFieldWidgetPrefix(
                                    titleFontSize: 16,
                                    titleFontFamily: AppThemData.semiBold,
                                    titleColor: AppColors.darkGrey10,
                                    title: "Name".tr,
                                    validator:(value) => value != null && value.isNotEmpty ? null : 'Name required'.tr,
                                    hintText: "Enter Name".tr,
                                    controller: controller.nameController.value,
                                    onPress: () {},
                                  ),
                                  TextFieldWidgetPrefix(
                                    titleFontSize: 16,
                                    titleFontFamily: AppThemData.semiBold,
                                    titleColor: AppColors.darkGrey10,
                                    readOnly: controller.watchManModel.value.email == null ? false : true,
                                    title: "Email".tr,
                                    hintText: "Enter Email".tr,
                                    controller: controller.emailController.value,
                                    validator: (value) => Constant.validateEmail(value),
                                    onPress: () {
                                      if (controller.watchManModel.value.email != null) {
                                        ShowToastDialog.showToast("Can't change email".tr);
                                      }
                                    },
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
                                  InkWell(
                                    onTap: () async {
                                      await Constant.selectDate(context).then((value) {
                                        if (value != null) {
                                          controller.dateOfBirthController.value.text = DateFormat('MMMM dd,yyyy').format(value);
                                        }
                                      });
                                    },
                                    child: TextFieldWidgetPrefix(
                                      titleFontSize: 16,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleColor: AppColors.darkGrey10,
                                      title: 'Date of Birth'.tr,
                                      onPress: () async {},
                                      validator:(value) => value != null && value.isNotEmpty ? null : 'Date od Birth required'.tr,
                                      controller: controller.dateOfBirthController.value,
                                      hintText: 'Select Date of Birth'.tr,
                                      enable: false,
                                    ),
                                  ),
                                  TextFieldWidgetPrefix(
                                    titleFontSize: 16,
                                    titleFontFamily: AppThemData.semiBold,
                                    titleColor: AppColors.darkGrey10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                    ],
                                    validator:(value) => value != null && value.isNotEmpty ? null : 'Salary required'.tr,
                                    title: "Salary".tr,
                                    hintText: "Enter Salary".tr,
                                    textInputType: const TextInputType.numberWithOptions(),
                                    controller: controller.salaryController.value,
                                    onPress: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: !keyboardIsOpen,
                            child: ButtonThem.buildButton(
                              btnHeight: 56,
                              txtSize: 16,
                              context,
                              title: controller.watchManModel.value.id != null ? "Update".tr : "Add".tr,
                              txtColor: AppColors.lightGrey01,
                              bgColor: AppColors.darkGrey10,
                              onPress: () {
                                controller.saveWatchManDetail();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
