// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:owner_app/themes/screen_size.dart';

import '../controllers/parking_details_screen_controller.dart';

class ParkingDetailsScreenView extends GetView<ParkingDetailsScreenController> {
  const ParkingDetailsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ParkingDetailsScreenController>(
        init: ParkingDetailsScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "Parking Details".tr, isBack: true, backgroundColor: AppColors.lightGrey02),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                          height: Responsive.height(18, context),
                          child: PageView.builder(
                            controller: PageController(viewportFraction: .89),
                            itemCount: controller.parkingImagesList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: NetworkImageWidget(
                                    height: 200,
                                    borderRadius: 12,
                                    imageUrl: controller.parkingModel.value.images![index],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.parkingModel.value.parkingName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${controller.parkingModel.value.address}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: AppThemData.regular, color: AppColors.darkGrey06),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: SvgPicture.asset(
                                controller.parkingModel.value.parkingType == "4"
                                    ? "assets/icons/ic_car.svg"
                                    : "assets/icons/ic_bike.svg",
                                color: AppColors.darkGrey03,
                              ),
                            ),
                            Text(controller.parkingModel.value.parkingType == "4" ? "4 Wheel" : "2 Wheel".tr,
                                style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06)),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: SvgPicture.asset(
                                "assets/icons/ic_star.svg",
                              ),
                            ),
                            Text(
                                Constant.calculateReview(
                                    reviewCount: controller.parkingModel.value.reviewCount,
                                    reviewSum: controller.parkingModel.value.reviewSum),
                                style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Parking Information".tr,
                      style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                    ),
                    const SizedBox(height: 12),
                    commonWidget(
                      imageAsset: "assets/icons/ic_place_marker.svg",
                      value: "${controller.parkingModel.value.parkingSpace} Spots Available",
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                      color: AppColors.darkGrey01,
                    ),
                    commonWidget(
                      imageAsset: "assets/icons/ic_clock.svg",
                      value: "${controller.parkingModel.value.startTime} - ${controller.parkingModel.value.endTime}",
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                      color: AppColors.darkGrey01,
                    ),
                    commonWidget(
                      imageAsset: "assets/icons/ic_call.svg",
                      value: "${controller.parkingModel.value.countryCode} ${controller.parkingModel.value.phoneNumber}",
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Parking Facilities".tr,
                      style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                    ),
                    ListView.separated(
                        padding: const EdgeInsets.only(top: 12),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: NetworkImageWidget(
                                      borderRadius: 0,
                                      imageUrl: controller.selectedParkingFacilitiesList[index].image.toString(),
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(controller.selectedParkingFacilitiesList[index].name.toString(),
                                      style: const TextStyle(color: AppColors.darkGrey06, fontFamily: AppThemData.medium)),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 0,
                            thickness: 1,
                            color: AppColors.darkGrey01,
                          );
                        },
                        itemCount: controller.selectedParkingFacilitiesList.length)
                  ],
                ),
              ),
            ),
          );
        });
  }
}

commonWidget({
  required String imageAsset,
  required String value,
}) {
  return Container(
    color: AppColors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(imageAsset,color: AppColors.darkGrey04,height: 22,width: 22,),
          const SizedBox(width: 14),
          Text(
            value,
            style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
          )
        ],
      ),
    ),
  );
}
