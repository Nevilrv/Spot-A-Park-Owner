import 'package:get/get.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class ParkingScreenController extends GetxController {
  RxList<ParkingModel> parkingModelList = <ParkingModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool parkingStatus = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getMyParkingList().then((value) {
      if (value != null) {
        parkingModelList.value = value;
      }
    });
    isLoading.value = true;
  }

  updateParkingList(int index, value, ParkingModel parkingModel) async {
    ShowToastDialog.showLoader("Please Wait");
    parkingModelList[index].active = value;
    parkingModelList.refresh();
    await FireStoreUtils.addParkingDetails(parkingModel).then((value) {
      ShowToastDialog.closeLoader();
    });
  }
}
