// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/tax_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/booking_summary_screen_controller.dart';

class BookingSummaryScreenView extends GetView<BookingSummaryScreenController> {
  const BookingSummaryScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingSummaryScreenController>(
        init: BookingSummaryScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(context, "Summary", isBack: true, backgroundColor: AppColors.white),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NetworkImageWidget(
                            borderRadius: 8,
                            imageUrl: "${controller.customerModel.value.profilePic}",
                            height: 48,
                            width: 48,
                            fit: BoxFit.fill,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${controller.customerModel.value.fullName}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey09, fontSize: 16),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "assets/icons/ic_message.svg",
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final Uri url = Uri.parse(
                                              "tel:${controller.customerModel.value.countryCode}${controller.customerModel.value.phoneNumber}");
                                          if (!await launchUrl(url)) {
                                            throw Exception('Could not launch ${Constant.supportEmail.toString()}'.tr);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_call.svg",
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '${controller.customerModel.value.email}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: AppThemData.regular,
                                      color: AppColors.darkGrey07,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Divider(
                          color: AppColors.darkGrey01,
                        ),
                      ),
                      Text(
                        'Booking Status'.tr,
                        style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Booking Status'.tr,
                                style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04, fontSize: 16),
                              ),
                            ),
                            Text(
                              controller.bookingModel.value.status == Constant.placed
                                  ? "Placed".tr
                                  : controller.bookingModel.value.status == Constant.onGoing
                                      ? "On Going".tr
                                      : controller.bookingModel.value.status == Constant.completed
                                          ? "Completed".tr
                                          : "Canceled".tr,
                              style: TextStyle(
                                  fontFamily: AppThemData.regular,
                                  color: controller.bookingModel.value.status == Constant.canceled ? AppColors.red04 : AppColors.green05,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (controller.bookingModel.value.status != Constant.canceled)
                        Text(
                          'Payment Status'.tr,
                          style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                        ),
                      if (controller.bookingModel.value.status != Constant.canceled)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Payment Status'.tr,
                                  style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04, fontSize: 16),
                                ),
                              ),
                              Text(
                                controller.bookingModel.value.paymentCompleted == true ? 'Completed'.tr : "Pending".tr,
                                style: TextStyle(
                                    fontFamily: AppThemData.regular,
                                    color: controller.bookingModel.value.paymentCompleted == true ? AppColors.green05 : AppColors.red04,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 15),
                      Text(
                        'Parking Information'.tr,
                        style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ParkingInformationWidget(name: "Parking ID".tr, value: "${controller.bookingModel.value.parkingId}"),
                            ParkingInformationWidget(name: "Vehicle Number".tr, value: "${controller.bookingModel.value.numberPlate}"),
                            ParkingInformationWidget(
                                name: "Start".tr,
                                value:
                                    "${Constant.timestampToDate(controller.bookingModel.value.bookingStartTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingStartTime!)}"),
                            ParkingInformationWidget(
                                name: "End".tr,
                                value:
                                    "${Constant.timestampToDate(controller.bookingModel.value.bookingEndTime!)}-${Constant.timestampToTime(controller.bookingModel.value.bookingEndTime!)}"),
                            ParkingInformationWidget(name: "Durations".tr, value: "${controller.bookingModel.value.duration} Hour"),
                          ],
                        ),
                      ),
                      Text(
                        'Parking Cost'.tr,
                        style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ParkingInformationWidget(
                                  name: "SubTotal".tr, value: Constant.amountShow(amount: controller.bookingModel.value.subTotal)),
                              ParkingInformationWidget(
                                  name: "Coupon Applied".tr, value: Constant.amountShow(amount: controller.couponAmount.toString())),
                              controller.bookingModel.value.taxList == null
                                  ? const SizedBox()
                                  : ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.bookingModel.value.taxList!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                        return ParkingInformationWidget(
                                            name:
                                                "${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                            value:
                                                "${Constant.amountShow(amount: Constant.calculateTax(amount: (double.parse(controller.bookingModel.value.subTotal.toString()) - double.parse(controller.couponAmount.toString())).toString(), taxModel: taxModel).toStringAsFixed(Constant.currencyModel!.decimalDigits!).toString())} ");
                                      },
                                    ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(
                                  color: AppColors.darkGrey01,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total Cost".tr,
                                      style: const TextStyle(fontFamily: AppThemData.medium, fontSize: 16, color: AppColors.darkGrey06),
                                    ),
                                  ),
                                  Text(
                                    Constant.amountShow(amount: controller.calculateAmount().toString()),
                                    style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 16, color: AppColors.darkGrey10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (controller.bookingModel.value.status == Constant.placed ||
                          controller.bookingModel.value.status == Constant.onGoing)
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                          child: Center(
                            child: ButtonThem.buildButton(
                              btnHeight: 56,
                              txtSize: 16,
                              btnWidthRatio: .60,
                              context,
                              title: controller.bookingModel.value.status == Constant.placed ? "Approved".tr : "Completed".tr,
                              txtColor: AppColors.lightGrey01,
                              bgColor: AppColors.darkGrey10,
                              onPress: () {
                                Get.toNamed(Routes.APPROVE_NUMBER_PLATE_SCREEN, arguments: {
                                  "bookingModel": controller.bookingModel.value,
                                  "customerModel": controller.customerModel.value
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ));
        });
  }
}

// ignore: must_be_immutable
class ParkingInformationWidget extends StatelessWidget {
  ParkingInformationWidget({super.key, required this.name, required this.value});

  String name;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04),
            ),
          ),
          Text(
            (value.length > 35) ? value.substring(0, 30) : value,
            style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey06),
          ),
        ],
      ),
    );
  }
}
