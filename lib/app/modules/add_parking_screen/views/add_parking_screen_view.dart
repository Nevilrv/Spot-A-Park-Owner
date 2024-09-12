import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_place_picker/flutter_place_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:owner_app/app/models/location_lat_lng.dart';
import 'package:owner_app/app/widget/network_image_widget.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/button_theme.dart';
import 'package:owner_app/themes/screen_size.dart';
import 'package:owner_app/utils/utils.dart';

import '../../../../themes/common_ui.dart';
import '../../../widget/mobile_number_textfield.dart';
import '../controllers/add_parking_screen_controller.dart';

class AddParkingScreenView extends StatelessWidget {
  const AddParkingScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return GetX<AddParkingScreenController>(
        init: AddParkingScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.lightGrey02,
              appBar: UiInterface().customAppBar(
                  context,
                  controller.parkingModel.value.id != null
                      ? "Edit Parking".tr
                      : "Add Parking".tr,
                  backgroundColor: AppColors.lightGrey02),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Form(
                                key: controller.formKey.value,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: AppColors.white,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Open/Close".tr,
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppThemData.semiBold,
                                                color: AppColors.darkGrey10),
                                          )),
                                          Transform.scale(
                                            scale: .8,
                                            child: CupertinoSwitch(
                                              activeColor: AppColors.green04,
                                              value: controller
                                                  .parkingStatus.value,
                                              onChanged: (value) {
                                                controller.parkingStatus.value =
                                                    value;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Parking For".tr,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppThemData.semiBold,
                                          color: AppColors.darkGrey10),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                      children: [
                                        SelectParkingTypeWidget(
                                          controller: controller,
                                          value: "2",
                                          imageAsset:
                                              "assets/icons/ic_bike.svg",
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Divider(
                                            color: AppColors.darkGrey01,
                                            height: 0,
                                          ),
                                        ),
                                        SelectParkingTypeWidget(
                                          controller: controller,
                                          value: "4",
                                          imageAsset: "assets/icons/ic_car.svg",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Parking Image".tr,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppThemData.semiBold,
                                          color: AppColors.darkGrey10),
                                    ),
                                    const SizedBox(height: 8),
                                    (controller.parkingImages.isNotEmpty)
                                        ? InkWell(
                                            onTap: () {
                                              buildBottomSheet(
                                                context,
                                                controller,
                                              );
                                            },
                                            child: Container(
                                              color: AppColors.white,
                                              height: Responsive.height(
                                                  20, context),
                                              width:
                                                  Responsive.width(90, context),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: GridView.builder(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    itemCount: controller
                                                        .parkingImages.length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing:
                                                                5),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Constant.hasValidUrl(
                                                                  controller
                                                                          .parkingImages[
                                                                      index]) ==
                                                              false
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Image.file(
                                                                File(controller
                                                                        .parkingImages[
                                                                    index]),
                                                                height: Responsive
                                                                    .height(20,
                                                                        context),
                                                                width: Responsive
                                                                    .width(80,
                                                                        context),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child:
                                                                  NetworkImageWidget(
                                                                borderRadius: 0,
                                                                imageUrl: controller
                                                                    .parkingImages[
                                                                        index]
                                                                    .toString(),
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: Responsive
                                                                    .height(20,
                                                                        context),
                                                                width: Responsive
                                                                    .width(80,
                                                                        context),
                                                              ),
                                                            );
                                                    },
                                                  )),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              buildBottomSheet(
                                                context,
                                                controller,
                                              );
                                            },
                                            child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(12),
                                              dashPattern: const [6, 6, 6, 6],
                                              color: AppColors.darkGrey10,
                                              child: Container(
                                                  color: AppColors.white,
                                                  height: Responsive.height(
                                                      20, context),
                                                  width: Responsive.width(
                                                      90, context),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.image,
                                                          color: AppColors
                                                              .darkGrey10,
                                                          size: 32),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Upload image".tr,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                AppThemData
                                                                    .regular),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFieldWidgetPrefix(
                                      validator: (value) =>
                                          value != null && value.isNotEmpty
                                              ? null
                                              : 'Parking name required'.tr,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_plus.svg",
                                          // ignore: deprecated_member_use
                                          color: AppColors.darkGrey04,
                                        ),
                                      ),
                                      title: "Parking Name".tr,
                                      titleColor: AppColors.darkGrey10,
                                      hintText: "Enter Parking Name".tr,
                                      controller: controller
                                          .parkingNameController.value,
                                      onPress: () {},
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Position data =
                                            await Utils.getCurrentLocation();
                                        PickResult? result =
                                            await Utils.showPlacePicker(context,
                                                lat: (controller.lat ??
                                                    data.latitude),
                                                lng: (controller.lng ??
                                                    data.longitude));
                                        if (result != null) {
                                          List<Placemark> address =
                                              await Utils.getAddress(
                                                  result.geometry!.location.lat,
                                                  result
                                                      .geometry!.location.lng);
                                          controller.lat =
                                              result.geometry!.location.lat;
                                          controller.lng =
                                              result.geometry!.location.lng;

                                          String street =
                                              address[0].street ?? "";
                                          String subLocality =
                                              address[0].subLocality ?? "";
                                          String locality =
                                              address[0].locality ?? "";
                                          String administrativeArea =
                                              address[0].administrativeArea ??
                                                  "";
                                          String country =
                                              address[0].country ?? "";
                                          String postalCode =
                                              address[0].postalCode ?? "";

                                          String formattedAddress =
                                              "${street.isNotEmpty ? "$street, " : ""}${subLocality.isNotEmpty ? "$subLocality, " : ""}${locality.isNotEmpty ? "$locality, " : ""}${administrativeArea.isNotEmpty ? "$administrativeArea, " : ""}${country.isNotEmpty ? "$country${postalCode.isNotEmpty ? " - $postalCode." : "."}" : ""}";

                                          controller.addressController.value
                                                  .text =
                                              formattedAddress.toString();
                                          controller.locationLatLng.value =
                                              LocationLatLng(
                                                  latitude: result
                                                      .geometry!.location.lat,
                                                  longitude: result
                                                      .geometry!.location.lng);
                                        }
                                      },
                                      child: TextFieldWidgetPrefix(
                                        validator: (value) =>
                                            value != null && value.isNotEmpty
                                                ? null
                                                : 'Address required'.tr,
                                        titleFontFamily: AppThemData.semiBold,
                                        titleFontSize: 16,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SvgPicture.asset(
                                              "assets/icons/ic_place_marker.svg"),
                                        ),
                                        maxLine: 2,
                                        title: "Address".tr,
                                        titleColor: AppColors.darkGrey10,
                                        hintText: "Enter Address".tr,
                                        controller:
                                            controller.addressController.value,
                                        enable: false,
                                        onPress: () {},
                                      ),
                                    ),
                                    MobileNumberTextField(
                                      titleColor: AppColors.darkGrey10,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      title: "Mobile Number".tr,
                                      controller: controller
                                          .phoneNumberController.value,
                                      countryCode: controller.countryCode.value,
                                      onPress: () {},
                                    ),
                                    TextFieldWidgetPrefix(
                                      validator: (value) =>
                                          value != null && value.isNotEmpty
                                              ? null
                                              : 'Parking price required'.tr,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      title: "Parking Price".tr,
                                      titleColor: AppColors.darkGrey10,
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_currency.svg"),
                                      ),
                                      hintText: "Enter Price".tr,
                                      controller:
                                          controller.priceController.value,
                                      textInputType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]')),
                                      ],
                                      onPress: () {},
                                    ),
                                    TextFieldWidgetPrefix(
                                      validator: (value) =>
                                          value != null && value.isNotEmpty
                                              ? null
                                              : 'Parking space required'.tr,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      title: "Parking Space".tr,
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_parkingspaces.svg"),
                                      ),
                                      titleColor: AppColors.darkGrey10,
                                      hintText: "Enter Parking Space".tr,
                                      controller: controller
                                          .parkingSpaceController.value,
                                      textInputType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]')),
                                      ],
                                      onPress: () {},
                                    ),
                                    TextFieldWidgetPrefix(
                                      validator: (value) =>
                                          value != null && value.isNotEmpty
                                              ? null
                                              : 'Start time required'.tr,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      titleColor: AppColors.darkGrey10,
                                      title: "Start Time".tr,
                                      readOnly: true,
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_clock.svg"),
                                      ),
                                      hintText: "Enter Start Time".tr,
                                      controller:
                                          controller.startTimeController.value,
                                      onPress: () async {
                                        await Constant.selectTime(context)
                                            .then((value) {
                                          if (value != null) {
                                            String time =
                                                '${value.hour}:${value.minute}:00';
                                            controller.startTimeController.value
                                                    .text =
                                                DateFormat.jm().format(
                                                    DateFormat("hh:mm:ss")
                                                        .parse(time));
                                          }
                                        });
                                      },
                                    ),
                                    TextFieldWidgetPrefix(
                                      validator: (value) =>
                                          value != null && value.isNotEmpty
                                              ? null
                                              : 'End time required'.tr,
                                      titleFontFamily: AppThemData.semiBold,
                                      titleFontSize: 16,
                                      titleColor: AppColors.darkGrey10,
                                      title: "End Time",
                                      readOnly: true,
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_clock.svg"),
                                      ),
                                      hintText: "Enter End Time",
                                      controller:
                                          controller.endTimeController.value,
                                      onPress: () async {
                                        await Constant.selectTime(context)
                                            .then((value) {
                                          if (value != null) {
                                            String time =
                                                '${value.hour}:${value.minute}:00';
                                            controller.endTimeController.value
                                                    .text =
                                                DateFormat.jm().format(
                                                    DateFormat("hh:mm:ss")
                                                        .parse(time));
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      'Select Facilities'.tr,
                                      style: const TextStyle(
                                          fontFamily: AppThemData.semiBold,
                                          color: AppColors.darkGrey10,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    ListView(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: controller.parkingFacilitiesList
                                          .map((item) => Column(
                                                children: [
                                                  Theme(
                                                    data: ThemeData(
                                                        unselectedWidgetColor:
                                                            AppColors
                                                                .darkGrey04),
                                                    child: CheckboxListTile(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16,
                                                              vertical: 4),
                                                      checkColor:
                                                          AppColors.white,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      activeColor:
                                                          AppColors.yellow04,
                                                      tileColor:
                                                          AppColors.white,
                                                      value: controller
                                                                  .selectedParkingFacilitiesList
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      item.id) ==
                                                              -1
                                                          ? false
                                                          : true,
                                                      dense: true,
                                                      title: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                NetworkImageWidget(
                                                              borderRadius: 0,
                                                              imageUrl: item
                                                                  .image
                                                                  .toString(),
                                                              height: 20,
                                                              width: 20,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              item.name
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: AppColors
                                                                      .darkGrey06,
                                                                  fontFamily:
                                                                      AppThemData
                                                                          .medium)),
                                                        ],
                                                      ),
                                                      onChanged: (value) {
                                                        if (value == true) {
                                                          controller
                                                              .selectedParkingFacilitiesList
                                                              .add(item);
                                                        } else {
                                                          controller
                                                              .selectedParkingFacilitiesList
                                                              .removeAt(controller
                                                                  .selectedParkingFacilitiesList
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      item.id));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.0),
                                                    child: Divider(
                                                      color:
                                                          AppColors.darkGrey01,
                                                      height: 0,
                                                    ),
                                                  )
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Visibility(
                                  visible: !keyboardIsOpen,
                                  child: ButtonThem.buildButton(
                                    btnHeight: 56,
                                    txtSize: 16,
                                    context,
                                    title: "Cancel".tr,
                                    txtColor: AppColors.darkGrey10,
                                    bgColor: AppColors.darkGrey01,
                                    onPress: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Expanded(
                                child: Visibility(
                                  visible: !keyboardIsOpen,
                                  child: ButtonThem.buildButton(
                                    btnHeight: 56,
                                    txtSize: 16,
                                    context,
                                    title:
                                        controller.parkingModel.value.id != null
                                            ? "Update Detail".tr
                                            : "Save".tr,
                                    txtColor: AppColors.lightGrey01,
                                    bgColor: AppColors.darkGrey10,
                                    onPress: () {
                                      if (controller.formKey.value.currentState!
                                          .validate()) {
                                        if (controller.parkingImages.isEmpty) {
                                          ShowToastDialog.showToast(
                                              "Please Add Images".tr);
                                          return;
                                        }
                                        controller.saveDetails();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ));
        });
  }
}

// ignore: must_be_immutable
class SelectParkingTypeWidget extends StatelessWidget {
  SelectParkingTypeWidget(
      {super.key, this.controller, this.value, this.imageAsset});

  AddParkingScreenController? controller;
  String? value;
  String? imageAsset;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: SvgPicture.asset(
                        // ignore: deprecated_member_use
                        imageAsset!, color: AppColors.darkGrey04, height: 22,
                        width: 22,
                      ),
                    ),
                    Text("$value Wheel".tr,
                        style: const TextStyle(fontFamily: AppThemData.medium)),
                  ],
                ),
                Radio(
                  value: value!,
                  groupValue: controller!.parkingType.value,
                  activeColor: AppColors.yellow04,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  onChanged: controller!.handleParkingChange,
                ),
              ],
            ),
          ),
        ));
  }
}

buildBottomSheet(BuildContext context, AddParkingScreenController controller) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            height: Responsive.height(22, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "please_select".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  controller.pickMultiImages(source: "Camera"),
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "camera".tr,
                              style: const TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickMultiImages(),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "gallery".tr,
                              style: const TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
      });
}
