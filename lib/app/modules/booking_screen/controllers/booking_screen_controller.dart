import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class BookingScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;

  ProfileScreenController profileScreenController = Get.put(ProfileScreenController());

  Rx<ParkingModel> selectedParkingModel = ParkingModel().obs;
  RxList<ParkingModel> parkingList = <ParkingModel>[].obs;

  Rx<DateTime> selectedDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxBool isLoading = true.obs;

  getOwnerProfile() async {
    isLoading.value = true;
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        ownerModel.value = value;
      }
    });
    await getParkingList();
  }

  getParkingList() async {
    await FireStoreUtils.getMyParkingList().then((value) {
      if (value != null) {
        parkingList.value = value;
        if (parkingList.isNotEmpty) {
          selectedParkingModel.value = parkingList.first;
          selectedDateTime.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        }
      }
    });
    isLoading.value = false;
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    getOwnerProfile();
    super.onInit();
  }
}
