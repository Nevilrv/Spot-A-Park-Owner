import 'package:get/get.dart';
import 'package:owner_app/app/models/watchman_model.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class WatchmanScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<WatchManModel> watchManList = <WatchManModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading.value = true;
    await FireStoreUtils.getWatchManProfiles().then((value) {
      if (value != null) {
        watchManList.value = value;
      }
      isLoading.value = false;
    });
  }
}
