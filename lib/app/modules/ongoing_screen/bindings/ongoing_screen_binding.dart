import 'package:get/get.dart';

import '../controllers/ongoing_screen_controller.dart';

class OngoingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OngoingScreenController>(
      () => OngoingScreenController(),
    );
  }
}
