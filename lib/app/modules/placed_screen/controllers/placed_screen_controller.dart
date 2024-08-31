import 'package:get/get.dart';
import 'package:owner_app/app/modules/booking_screen/controllers/booking_screen_controller.dart';

class PlacedScreenController extends GetxController {
  BookingScreenController bookingScreenController = Get.find<BookingScreenController>();

  RxBool isWaiting = true.obs;
}
