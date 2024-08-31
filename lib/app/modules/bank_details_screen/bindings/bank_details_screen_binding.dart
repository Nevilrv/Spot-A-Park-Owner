import 'package:get/get.dart';

import '../controllers/bank_details_screen_controller.dart';

class BankDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankDetailsScreenController>(
      () => BankDetailsScreenController(),
    );
  }
}
