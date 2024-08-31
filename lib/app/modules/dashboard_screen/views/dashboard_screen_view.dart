// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';

import '../controllers/dashboard_screen_controller.dart';

class DashboardScreenView extends GetView<DashboardScreenController> {
  const DashboardScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.pageList[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: controller.selectedIndex.value,
          showUnselectedLabels: true,
          onTap: (value) {
            controller.selectedIndex.value = value;
          },
          selectedItemColor: AppColors.yellow04,
          showSelectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: AppThemData.bold,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: AppColors.darkGrey04,
          unselectedLabelStyle: const TextStyle(
            fontFamily: AppThemData.medium,
            fontSize: 12,
          ),
          backgroundColor: AppColors.darkGrey10,
          items: [
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset("assets/icons/ic_list_plus_active.svg"),
                icon: SvgPicture.asset("assets/icons/ic_list_plus.svg"),
                label: "Booking".tr),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset("assets/icons/ic_list_check_active.svg"),
                icon: SvgPicture.asset("assets/icons/ic_list_check.svg"),
                label: "Parking".tr),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset("assets/icons/ic_user_list_active.svg"),
                icon: SvgPicture.asset("assets/icons/ic_user_list.svg"),
                label: "Watch Men".tr),
            BottomNavigationBarItem(
                activeIcon: SvgPicture.asset("assets/icons/ic_my_profile_active.svg"),
                icon: SvgPicture.asset(
                  "assets/icons/ic_my_profile.svg",
                  color: AppColors.darkGrey04,
                ),
                label: "Profile".tr),
          ],
        ),
      ),
    );
  }
}
