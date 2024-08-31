// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/modules/booking_canceled_screen/views/booking_canceled_screen_view.dart';
import 'package:owner_app/app/modules/booking_completed_screen/views/booking_completed_screen_view.dart';
import 'package:owner_app/app/modules/ongoing_screen/views/ongoing_screen_view.dart';
import 'package:owner_app/app/modules/placed_screen/views/placed_screen_view.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/booking_screen_controller.dart';

class BookingScreenView extends StatelessWidget {
  const BookingScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BookingScreenController>(
        init: BookingScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            // ignore: unrelated_type_equality_checks
            appBar: (controller.profileScreenController.isBookingScreen.value)
                ? UiInterface().customAppBar(
                    backgroundColor: AppColors.lightGrey02,
                    context,
                    "Booking".tr,
                    isBack: true,
                    onBackTap: () {
                      controller.profileScreenController.isBookingScreen.value = false;
                      Get.back();
                    },
                  )
                : AppBar(
                    elevation: 0,
                    backgroundColor: AppColors.yellow04,
                    surfaceTintColor: Colors.transparent,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        (controller.isLoading.value) ? "" : "Welcome, ${controller.ownerModel.value.fullName}",
                        style: const TextStyle(fontSize: 14, fontFamily: AppThemData.medium, color: AppColors.yellow09),
                      ),
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.WALLET_SCREEN);
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 16.0, top: 16,left: 16),
                            child: SvgPicture.asset(
                              "assets/icons/ic_wallet.svg",
                              color: AppColors.darkGrey07,
                            )),
                      )
                    ],
                    automaticallyImplyLeading: false,
                  ),

            body: (controller.isLoading.value)
                ? Constant.loader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!controller.profileScreenController.isBookingScreen.value)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
                          decoration: const BoxDecoration(color: AppColors.yellow04),
                          child: Text(
                            "Find the best place for parking\nyour vehicle".tr,
                            style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 20, color: AppColors.darkGrey10),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Parking".tr,
                              style: const TextStyle(color: AppColors.darkGrey06, fontFamily: AppThemData.medium),
                            ),
                            DropdownButtonFormField<ParkingModel>(
                                isExpanded: false,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.lightGrey10,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(color: Colors.red),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  disabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                                  ),
                                  hintStyle: const TextStyle(fontFamily: AppThemData.regular),
                                ),
                                value: controller.selectedParkingModel.value.id == null ? null : controller.selectedParkingModel.value,
                                onChanged: (value) {
                                  controller.selectedParkingModel.value = value!;
                                },
                                style: const TextStyle(color: AppColors.darkGrey10),
                                hint: Text(
                                  "Select Your Parking".tr,
                                  style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10),
                                ),
                                items: controller.parkingList.map((item) {
                                  return DropdownMenuItem<ParkingModel>(
                                    value: item,
                                    child: Text(item.parkingName.toString(),
                                        style: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10)),
                                  );
                                }).toList()),
                            SizedBox(
                              height: 150,
                              child: SfDateRangePicker(
                                headerHeight: 60,
                                showNavigationArrow: true,
                                monthViewSettings: const DateRangePickerMonthViewSettings(
                                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                      textStyle: TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey09)),
                                  firstDayOfWeek: DateTime.monday,
                                  numberOfWeeksInView: 1,
                                ),
                                todayHighlightColor: AppColors.darkGrey09,
                                headerStyle: const DateRangePickerHeaderStyle(
                                    textAlign: TextAlign.center,
                                    textStyle: TextStyle(fontFamily: AppThemData.bold, color: AppColors.grey10, fontSize: 18)),
                                selectionMode: DateRangePickerSelectionMode.single,
                                view: DateRangePickerView.month,
                                monthCellStyle: const DateRangePickerMonthCellStyle(
                                    textStyle: TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey06)),
                                selectionColor: AppColors.yellow04,
                                selectionTextStyle: const TextStyle(fontFamily: AppThemData.semiBold, color: AppColors.darkGrey10),
                                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                                  controller.selectedDateTime.value = dateRangePickerSelectionChangedArgs.value;
                                  log(controller.selectedDateTime.value.toString());
                                },
                                initialSelectedDate: DateTime.now(),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: AppColors.lightGrey06, borderRadius: BorderRadius.circular(40)),
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                isScrollable: (Constant.getLanguage().name == "English") ? true : false,
                                onTap: (value) {},
                                controller: controller.tabController,
                                labelStyle: const TextStyle(color: Colors.black, fontFamily: AppThemData.medium),
                                unselectedLabelStyle: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.regular),
                                indicator: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.yellow04),
                                indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                labelColor: Colors.black,
                                unselectedLabelColor: AppColors.darkGrey04,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(
                                    text: "Placed".tr,
                                  ),
                                  Tab(
                                    text: "On Going".tr,
                                  ),
                                  Tab(
                                    text: "Completed".tr,
                                  ),
                                  Tab(
                                    text: "Canceled".tr,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(controller: controller.tabController, children: const [
                          PlacedScreenView(),
                          OngoingScreenView(),
                          BookingCompletedScreenView(),
                          BookingCanceledScreenView()
                        ]),
                      ),
                    ],
                  ),
          );
        });
  }
}
