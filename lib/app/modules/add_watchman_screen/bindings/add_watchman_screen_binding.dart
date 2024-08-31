import 'package:get/get.dart';

import '../controllers/add_watchman_screen_controller.dart';

class AddWatchmanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWatchmanScreenController>(
      () => AddWatchmanScreenController(),
    );
  }
}
