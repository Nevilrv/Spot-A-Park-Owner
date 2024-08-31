import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashScreenController(),
      builder: (GetxController controller) {
        return Scaffold(
          backgroundColor: AppColors.yellow04,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(height: 24),
                const Text(
                  "ParkEasy",
                  style: TextStyle(fontFamily: AppThemData.bold, fontWeight: FontWeight.w900, color: Colors.black, fontSize: 32),
                ),
                const SizedBox(height: 3),
                const Text(
                  "Parking Made Effortless",
                  style: TextStyle(fontFamily: AppThemData.regular, color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
