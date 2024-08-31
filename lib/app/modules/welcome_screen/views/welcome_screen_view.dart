import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';

import '../controllers/welcome_screen_controller.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.yellow04,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Elevate Your Parking Experience with ParkEasy",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppThemData.bold, fontSize: 24, color: AppColors.darkGrey10),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Enjoy a seamless and stress-free parking experience with ParkEasy",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey08, fontSize: 16),
              ),
              const SizedBox(
                height: 24,
              ),
              ButtonThem.buildButton(
                btnWidthRatio: .7,
                btnHeight: 56,
                txtSize: 16,
                context,
                title: "Log in with Mobile Number",
                txtColor: AppColors.lightGrey01,
                bgColor: AppColors.darkGrey10,
                onPress: () {
                  Get.toNamed(Routes.LOGIN_SCREEN);
                },
              ),
              const SizedBox(
                height: 76,
              ),
            ],
          ),
        ));
  }
}
