import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/themes/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey02,
      appBar: AppBar(
        backgroundColor: AppColors.yellow04,
        title: const Text('HomeView'),
      ),
      body: const Center(
        child: Text("Hello"),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "",
          onPressed: () {
            Get.toNamed(Routes.ADD_PARKING_SCREEN);
          },
          child: const Icon(Icons.add)),
    );
  }
}
