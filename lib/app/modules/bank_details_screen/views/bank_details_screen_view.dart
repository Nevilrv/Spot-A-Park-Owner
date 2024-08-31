import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/common_ui.dart';

import '../controllers/bank_details_screen_controller.dart';

class BankDetailsScreenView extends GetView<BankDetailsScreenController> {
  const BankDetailsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: AppColors.lightGrey02,
          appBar: UiInterface().customAppBar(backgroundColor: AppColors.lightGrey02, context, "Bank Details".tr, isBack: true),
          body: (controller.isLoading.value)
              ? Constant.loader()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "Bank Account Holder's Name".tr,
                        hintText: "Enter Bank Account Holder's Name".tr,
                        controller: controller.accountHolderNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "Bank Account Number/IBAN".tr,
                        hintText: "Enter Bank Account Number/IBAN".tr,
                        controller: controller.accountNumberController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "SWIFT/IFSC Code".tr,
                        hintText: "Enter SWIFT/IFSC Code".tr,
                        controller: controller.swiftCodeController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "Bank Name".tr,
                        hintText: "Enter Bank Name".tr,
                        controller: controller.bankNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "Bank Branch City".tr,
                        hintText: "Enter Bank Branch City".tr,
                        controller: controller.branchCityNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidgetPrefix(
                        titleFontSize: 16,
                        titleFontFamily: AppThemData.semiBold,
                        titleColor: AppColors.darkGrey10,
                        title: "Bank Branch Country".tr,
                        hintText: "Enter Bank Branch Country".tr,
                        controller: controller.branchCountryNameController.value,
                        onPress: () {},
                      ),
                      ButtonThem.buildButton(
                        btnHeight: 56,
                        txtSize: 16,
                        context,
                        title: "Save Details".tr,
                        txtColor: AppColors.lightGrey01,
                        bgColor: AppColors.darkGrey10,
                        onPress: () {
                          controller.saveBankDetails();
                        },
                      ),
                    ]),
                  ),
                )),
    );
  }
}
