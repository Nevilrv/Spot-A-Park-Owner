import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/app/widget/text_field_suffix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

import '../controllers/approve_number_plate_screen_controller.dart';

class ApproveNumberPlateScreenView extends GetView<ApproveNumberPlateScreenController> {
  const ApproveNumberPlateScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightGrey02,
        appBar: UiInterface().customAppBar(
          backgroundColor: AppColors.lightGrey02,
          context,
          "Booking Details".tr,
          isBack: true,
        ),
        body: Obx(()=>(controller.isLoading.value)
            ? Center(
          child: Lottie.asset(
            "assets/gif/car-number-plate.json",
            width: 150,
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: NetworkImageWidget(
                              borderRadius: 8,
                              imageUrl: controller.customerModel.value.profilePic.toString(),
                              width: 60,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.customerModel.value.fullName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18, fontFamily: AppThemData.semiBold, color: AppColors.darkGrey09),
                                ),
                                const SizedBox(height: 9),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_phonecall.svg",
                                      color: AppColors.darkGrey03,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${controller.customerModel.value.countryCode} ${controller.customerModel.value.phoneNumber}",
                                      style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 6.0),
                                            child: SvgPicture.asset(
                                              controller.bookingModel.value.parkingDetails!.parkingType == "4"
                                                  ? "assets/icons/ic_car.svg"
                                                  : "assets/icons/ic_bike.svg",
                                              color: AppColors.darkGrey03,
                                            ),
                                          ),
                                          Text(
                                              controller.bookingModel.value.parkingDetails!.parkingType == "4"
                                                  ? "4 Wheel"
                                                  : "2 Wheel".tr,
                                              style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(
                          color: AppColors.darkGrey01,
                        ),
                      ),
                      Obx(() => TextFieldWidgetSuffix(
                        suffix: InkWell(
                          onTap: () {
                            controller.getLicensePlate();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SvgPicture.asset("assets/icons/ic_qrcode.svg", color: AppColors.darkGrey04),
                          ),
                        ),
                        title: "Vehicle Number".tr,
                        hintText: "Enter Vehicle Number".tr,
                        controller: controller.numberPlateController.value,
                        onPress: () {},
                      )),
                    ],
                  ),
                ),
              ),
              ButtonThem.buildButton(
                btnHeight: 56,
                txtSize: 16,
                btnWidthRatio: .60,
                context,
                title: controller.bookingModel.value.status == Constant.placed ? "Check in".tr : "Check Out".tr,
                txtColor: AppColors.lightGrey01,
                bgColor: AppColors.darkGrey10,
                onPress: () {
                  if (controller.bookingModel.value.numberPlate != controller.numberPlateController.value.text) {
                    ShowToastDialog.showToast("Vehicle number not same as booked vehicle number");
                  } else {
                    ShowToastDialog.showLoader("Please wait..");
                    if (controller.bookingModel.value.status == Constant.placed) {
                      controller.bookingModel.value.id = controller.bookingModel.value.id;
                      controller.bookingModel.value.status = Constant.onGoing;
                      controller.bookingModel.value.checkIn = Timestamp.now();
                      FireStoreUtils.updateBooking(controller.bookingModel.value).then((value) {
                        ShowToastDialog.closeLoader();
                        ShowToastDialog.showToast("${controller.customerModel.value.fullName} Check in Successful");
                        Get.back();
                      });
                    } else {
                      controller.bookingModel.value.id = controller.bookingModel.value.id;
                      controller.bookingModel.value.status = Constant.completed;
                      controller.bookingModel.value.checkOut = Timestamp.now();
                      FireStoreUtils.updateBooking(controller.bookingModel.value).then((value) {
                        ShowToastDialog.closeLoader();
                        ShowToastDialog.showToast("${controller.customerModel.value.fullName} Check out Successful");
                        Get.back();
                      });
                      ShowToastDialog.closeLoader();
                    }
                  }
                },
              ),
            ],
          ),
        )));
  }
}
