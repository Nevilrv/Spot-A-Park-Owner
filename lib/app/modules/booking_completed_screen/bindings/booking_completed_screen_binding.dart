import 'package:get/get.dart';

import '../controllers/booking_completed_screen_controller.dart';

class BookingCompletedScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingCompletedScreenController>(
      () => BookingCompletedScreenController(),
    );
  }
}
