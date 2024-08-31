// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

import '../controllers/parking_screen_controller.dart';

class ParkingScreenView extends StatelessWidget {
  const ParkingScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ParkingScreenController>(
        init: ParkingScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "Parking".tr, isBack: false, backgroundColor: AppColors.yellow04),
            body: (controller.isLoading.value)
                ? (controller.parkingModelList.isEmpty)
                    ? Constant.showEmptyView(message: "No Parking Added".tr)
                    : ListView.builder(
                        itemCount: controller.parkingModelList.length,
                        itemBuilder: (context, index) {
                          ParkingModel parkingModel = controller.parkingModelList[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkImageWidget(
                                      imageUrl: parkingModel.images![0].toString(),
                                      fit: BoxFit.fill,
                                      width: 48,
                                      height: 48,
                                      borderRadius: 12,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                parkingModel.parkingName.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.toNamed(Routes.ADD_PARKING_SCREEN, arguments: {"parkingModel": parkingModel})
                                                      ?.then((value) {
                                                    controller.getData();
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/ic_edit.svg",
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${parkingModel.address}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.darkGrey06),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, right: 6, top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            controller.parkingModelList[index].parkingType == "4"
                                                ? "assets/icons/ic_car.svg"
                                                : "assets/icons/ic_bike.svg",
                                            color: AppColors.darkGrey03,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(controller.parkingModelList[index].parkingType == "4" ? "4 Wheel" : "2 Wheel".tr,
                                              style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Status".tr,
                                              style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04)),
                                          const SizedBox(width: 10),
                                          Transform.scale(
                                            scale: .8,
                                            child: CupertinoSwitch(
                                              activeColor: AppColors.green04,
                                              value: parkingModel.active!,
                                              onChanged: (value) async {
                                                ShowToastDialog.showLoader("Please wait...".tr);
                                                parkingModel.active = value;
                                                await FireStoreUtils.addParkingDetails(parkingModel).then((value) {
                                                  controller.getData();
                                                  ShowToastDialog.closeLoader();
                                                  ShowToastDialog.showToast("Parking Status Updated".tr);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Divider(
                                    color: AppColors.darkGrey01,
                                    thickness: 1,
                                  ),
                                ),
                                FilledButton.tonal(
                                    onPressed: () {
                                      Get.toNamed(Routes.PARKING_DETAILS_SCREEN, arguments: {"parkingModel": parkingModel})?.then((value) {
                                        controller.getData();
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.yellow04, minimumSize: Size(MediaQuery.of(context).size.width, 50)),
                                    child:  Text(
                                      "View Details".tr,
                                      style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                                    ))
                              ],
                            ),
                          );
                        },
                      )
                : Constant.loader(),
            floatingActionButton: FloatingActionButton(
                heroTag: "",
                backgroundColor: AppColors.yellow04,
                onPressed: () {
                  Get.toNamed(Routes.ADD_PARKING_SCREEN)?.then((value) {
                    controller.getData();
                  });
                },
                child: const Icon(Icons.add)),
          );
        });
  }
}
