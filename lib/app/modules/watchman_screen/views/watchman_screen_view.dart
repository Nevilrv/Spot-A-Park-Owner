// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/watchman_model.dart';
import 'package:owner_app/app/modules/watchman_screen/controllers/watchman_screen_controller.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';

class WatchmanScreenView extends StatelessWidget {
  const WatchmanScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WatchmanScreenController>(
        init: WatchmanScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "WatchMan".tr, isBack: false, backgroundColor: AppColors.yellow04),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : (controller.watchManList.isEmpty)
                    ? Constant.showEmptyView(message: "No WatchMan Added".tr)
                    : ListView.builder(
                        itemCount: controller.watchManList.length,
                        itemBuilder: (context, index) {
                          WatchManModel watchManModel = controller.watchManList[index];
                          return InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ADD_WATCHMAN_SCREEN, arguments: {"watchManModel": watchManModel})?.then((value) {
                                controller.getData();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              width: double.infinity,
                              color: AppColors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: watchManModel.image.toString(),
                                    fit: BoxFit.fill,
                                    width: 48,
                                    height: 48,
                                    borderRadius: 12,
                                    errorWidget: null,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          watchManModel.name.toString(),
                                          style:
                                              const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.semiBold, fontSize: 16),
                                        ),
                                        Text(
                                          watchManModel.email.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              const TextStyle(color: AppColors.darkGrey10, fontFamily: AppThemData.regular, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/ic_edit_line.svg",
                                    color: AppColors.darkGrey10,
                                    height: 22,
                                    width: 22,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      shareEmailPassword(watchManModel.email.toString(), watchManModel.password.toString());
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_share.svg",
                                      color: AppColors.darkGrey10,
                                      height: 22,
                                      width: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.yellow04,
                heroTag: " ",
                onPressed: () {
                  Get.toNamed(Routes.ADD_WATCHMAN_SCREEN)?.then((value) {
                    controller.getData();
                  });
                },
                child: const Icon(Icons.add)),
          );
        });
  }
}

Future<void> shareEmailPassword(String email, String password) async {
  await FlutterShare.share(
    title: 'Spot A Park'.tr,
    text: 'Hey there, Your Watchman App Login \n\nEmail :- $email\nPassword :- $password',
  );
}
