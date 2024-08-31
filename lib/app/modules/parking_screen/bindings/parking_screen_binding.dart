import 'package:get/get.dart';

import '../controllers/parking_screen_controller.dart';

class ParkingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingScreenController>(
      () => ParkingScreenController(),
    );
  }
}
