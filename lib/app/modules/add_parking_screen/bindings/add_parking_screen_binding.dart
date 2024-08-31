import 'package:get/get.dart';

import '../controllers/add_parking_screen_controller.dart';

class AddParkingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddParkingScreenController>(
      () => AddParkingScreenController(),
    );
  }
}
