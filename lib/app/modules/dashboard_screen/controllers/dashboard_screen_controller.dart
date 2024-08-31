import 'package:get/get.dart';
import 'package:owner_app/app/modules/booking_screen/views/booking_screen_view.dart';
import 'package:owner_app/app/modules/parking_screen/views/parking_screen_view.dart';
import 'package:owner_app/app/modules/profile_screen/views/profile_screen_view.dart';
import 'package:owner_app/app/modules/watchman_screen/views/watchman_screen_view.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList pageList = [const BookingScreenView(), const ParkingScreenView(), const WatchmanScreenView(), const ProfileScreenView()].obs;
}
