import 'package:get/get.dart';

import '../controllers/parking_details_screen_controller.dart';

class ParkingDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingDetailsScreenController>(
      () => ParkingDetailsScreenController(),
    );
  }
}
