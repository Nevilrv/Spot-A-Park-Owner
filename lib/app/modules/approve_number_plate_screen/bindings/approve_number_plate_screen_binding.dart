import 'package:get/get.dart';

import '../controllers/approve_number_plate_screen_controller.dart';

class ApproveNumberPlateScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApproveNumberPlateScreenController>(
      () => ApproveNumberPlateScreenController(),
    );
  }
}
