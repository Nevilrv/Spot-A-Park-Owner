import 'package:get/get.dart';

import '../controllers/booking_canceled_screen_controller.dart';

class BookingCanceledScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingCanceledScreenController>(
      () => BookingCanceledScreenController(),
    );
  }
}
