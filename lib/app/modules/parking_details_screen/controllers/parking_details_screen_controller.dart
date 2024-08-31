import 'package:get/get.dart';
import 'package:owner_app/app/models/parking_facilities_model.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class ParkingDetailsScreenController extends GetxController {
  Rx<ParkingModel> parkingModel = ParkingModel().obs;
  RxList<String> parkingImagesList = <String>[].obs;
  RxList<ParkingFacilitiesModel> selectedParkingFacilitiesList = <ParkingFacilitiesModel>[].obs;
  RxBool isLoading = true.obs;

  getArguments() async {
    dynamic argument = Get.arguments;
    if (argument != null) {
      parkingModel.value = argument['parkingModel'];
      await FireStoreUtils.getOwnerParkingDetail(parkingModel.value.id.toString()).then((value) {
        if (value != null) {
          parkingModel.value = value;
          parkingImagesList.value = value.images!.cast<String>();

          for (var facilities in value.facilities!) {
            selectedParkingFacilitiesList.add(facilities);
          }
        }
      });
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getArguments();
    super.onInit();
  }
}
