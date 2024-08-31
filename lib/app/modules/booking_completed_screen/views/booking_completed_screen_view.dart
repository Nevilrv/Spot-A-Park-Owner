// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/booking_model.dart';
import 'package:owner_app/app/models/customer_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/constant/collection_name.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

import '../controllers/booking_completed_screen_controller.dart';

class BookingCompletedScreenView extends GetView<BookingCompletedScreenController> {
  const BookingCompletedScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<BookingCompletedScreenController>(
        init: BookingCompletedScreenController(),
        builder: (controller) {
          return Container(
            color: AppColors.lightGrey02,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(CollectionName.bookParkingOrder)
                    .where("parkingId", isEqualTo: controller.bookingScreenController.selectedParkingModel.value.id.toString())
                    .where('bookingDate', isEqualTo: Timestamp.fromDate(controller.bookingScreenController.selectedDateTime.value))
                    .where('status', isEqualTo: Constant.completed)
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center( child: Constant.showEmptyView(message: "No completed parking found".tr),);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Constant.loader();
                  }
                  return snapshot.data!.docs.isEmpty
                      ? Center(
                      child: Constant.showEmptyView(message: "No completed parking found".tr)
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = BookingModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                            return FutureBuilder<CustomerModel?>(
                              future: FireStoreUtils.getCustomerByCustomerID(bookingModel.customerId.toString()), // async work
                              builder: (BuildContext context, AsyncSnapshot<CustomerModel?> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const SizedBox();
                                  default:
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      CustomerModel customerModel = snapshot.data!;
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: NetworkImageWidget(
                                                borderRadius: 8,
                                                imageUrl: customerModel.profilePic.toString(),
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
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${customerModel.fullName}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 18, fontFamily: AppThemData.semiBold, color: AppColors.darkGrey09),
                                                        ),
                                                      ),
                                                      Text(
                                                        Constant.amountShow(amount: bookingModel.subTotal),
                                                        textAlign: TextAlign.end,
                                                        style: const TextStyle(
                                                            fontSize: 18, fontFamily: AppThemData.semiBold, color: AppColors.darkGrey09),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 9),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_parkingspaces.svg",
                                                        color: AppColors.darkGrey03,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        "${bookingModel.numberPlate}",
                                                        style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey07),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/ic_phonecall.svg",
                                                              color: AppColors.darkGrey03,
                                                            ),
                                                            const SizedBox(width: 6),
                                                            Text(
                                                              "${customerModel.countryCode} ${customerModel.phoneNumber}",
                                                              style: const TextStyle(
                                                                  fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.toNamed(Routes.BOOKING_SUMMARY_SCREEN, arguments: {
                                                            "bookingModel": bookingModel,
                                                            "customerModel": customerModel,
                                                          });
                                                        },
                                                        child:  Text(
                                                          "View Details".tr,
                                                          style: const TextStyle(color: AppColors.yellow04, fontFamily: AppThemData.semiBold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                }
                              },
                            );
                          },
                        );
                }),
          );
        });
  }
}
