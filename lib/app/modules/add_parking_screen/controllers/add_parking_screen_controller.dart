import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owner_app/app/models/location_lat_lng.dart';
import 'package:owner_app/app/models/parking_facilities_model.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/models/positions_model.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';
import 'package:owner_app/utils/utils.dart';

class AddParkingScreenController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  Rx<TextEditingController> parkingNameController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> parkingSpaceController =
      TextEditingController().obs;
  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<TextEditingController> startTimeController = TextEditingController().obs;
  Rx<TextEditingController> endTimeController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  double? lat;
  double? lng;
  RxString countryCode = "+91".obs;

  RxBool isLoading = true.obs;
  RxBool parkingStatus = true.obs;

  final ImagePicker imagePicker = ImagePicker();
  RxList<String> parkingImages = <String>[].obs;
  RxString parkingType = "2".obs;

  Rx<LocationLatLng> locationLatLng = LocationLatLng().obs;
  Rx<ParkingModel> parkingModel = ParkingModel().obs;
  RxList<ParkingFacilitiesModel> parkingFacilitiesList =
      <ParkingFacilitiesModel>[].obs;
  RxList<ParkingFacilitiesModel> selectedParkingFacilitiesList =
      <ParkingFacilitiesModel>[].obs;

  void handleParkingChange(String? value) {
    parkingType.value = value!;
  }

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  getFacilities() async {
    await FireStoreUtils.getParkingFacilities().then((value) {
      parkingFacilitiesList.value = value;
    });
    update();
  }

  getLocation() async {
    Constant.currentLocation = await Utils.getCurrentLocation();
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        Constant.currentLocation!.latitude,
        Constant.currentLocation!.longitude);
    Constant.country = placeMarks.first.country;
    log("---------${Constant.country}");
  }

  getArguments() async {
    isLoading.value = true;
    dynamic argument = Get.arguments;
    if (argument != null) {
      parkingModel.value = argument['parkingModel'];
      await FireStoreUtils.getOwnerParkingDetail(
              parkingModel.value.id.toString())
          .then((value) {
        if (value != null) {
          parkingModel.value = value;
          parkingImages.value = value.images!.cast<String>();
          parkingNameController.value.text = value.parkingName!;
          parkingSpaceController.value.text = value.parkingSpace!;
          locationLatLng.value = value.location!;
          parkingStatus.value = value.active!;
          addressController.value.text = value.address!;
          parkingType.value = value.parkingType!;
          priceController.value.text = value.perHrRate!;
          startTimeController.value.text = value.startTime!;
          endTimeController.value.text = value.endTime!;
          countryCode.value = value.countryCode!;
          phoneNumberController.value.text = value.phoneNumber!;

          for (var facilities in value.facilities!) {
            selectedParkingFacilitiesList.add(facilities);
          }
        }
      });
    }
    getLocation();
    getFacilities();
    isLoading.value = false;
  }

  saveDetails() async {
    if (formKey.value.currentState!.validate()) {
      ShowToastDialog.showLoader("Please Wait");
      if (parkingImages.isNotEmpty &&
          Constant.hasValidUrl(parkingImages[0]) == false) {
        parkingImages.value = await Constant.uploadParkingImage(parkingImages);
      }

      if (parkingModel.value.id == null || parkingModel.value.ownerId == null) {
        parkingModel.value.id = Constant.getUuid();
        parkingModel.value.ownerId = FireStoreUtils.getCurrentUid();
      }

      parkingModel.value.parkingName = parkingNameController.value.text;
      parkingModel.value.images = parkingImages;
      parkingModel.value.address = addressController.value.text;
      parkingModel.value.parkingType = parkingType.value;
      parkingModel.value.parkingSpace = parkingSpaceController.value.text;
      parkingModel.value.location = locationLatLng.value;
      parkingModel.value.perHrRate = priceController.value.text;
      parkingModel.value.active = parkingStatus.value;
      parkingModel.value.startTime = startTimeController.value.text;
      parkingModel.value.facilities = selectedParkingFacilitiesList;
      parkingModel.value.countryCode = countryCode.value;
      parkingModel.value.phoneNumber = phoneNumberController.value.text;
      parkingModel.value.endTime = endTimeController.value.text;

      GeoFirePoint position = GeoFlutterFire().point(
          latitude: locationLatLng.value.latitude!,
          longitude: locationLatLng.value.longitude!);
      parkingModel.value.position =
          Positions(geoPoint: position.geoPoint, geohash: position.hash);

      await FireStoreUtils.addParkingDetails(parkingModel.value).then((value) {
        Get.back(result: true);

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Parking Information save");
      });
    }
  }

  Future pickMultiImages({String? source}) async {
    try {
      if (source == "Camera") {
        XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

        if (image == null) return;
        Get.back();

        parkingImages.add(image.path);
      } else {
        List<XFile>? images = await imagePicker.pickMultiImage();
        if (images.isEmpty) return;
        Get.back();

        parkingImages.clear();
        for (var image in images) {
          parkingImages.add(image.path);
        }
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
