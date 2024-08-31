import 'package:get/get.dart';

import '../controllers/watchman_screen_controller.dart';

class WatchmanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchmanScreenController>(
      () => WatchmanScreenController(),
    );
  }
}
