import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:owner_app/app/models/currency_model.dart';
import 'package:owner_app/app/models/language_model.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/models/tax_model.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/utils/fire_store_utils.dart';
import 'package:owner_app/utils/preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Constant {
  static const userPlaceHolder = 'assets/images/user_placeholder.png';

  static const String googleLoginType = 'google';
  static const String phoneLoginType = 'phone';
  static const String appleLoginType = "apple";

  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String supportEmail = "";

  static String minimumAmountToWithdrawal = "0";
  static String mapAPIKey = "";
  static String plateRecognizerApiToken = "";

  static Position? currentLocation;
  static String? country;
  static OwnerModel? ownerModel;
  static CurrencyModel? currencyModel;

  static const String placed = "placed";
  static const String onGoing = "onGoing";
  static const String completed = "completed";
  static const String canceled = "canceled";

  static const String pending = "pending";
  static const String success = "success";
  static const String rejected = "rejected";

  static String getUuid() {
    return const Uuid().v4();
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.black),
    );
  }

  static getRandomNumber() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code;
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    if (reviewCount == "0.0" && reviewSum == "0.0") {
      return "0.0";
    }
    return (double.parse(reviewSum.toString()) / double.parse(reviewCount.toString())).toStringAsFixed(1);
  }

  static String amountShow({required String? amount}) {
    if (Constant.currencyModel!.symbolAtRight == true) {
      return "${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.currencyModel!.symbol.toString()}";
    } else {
      return "${Constant.currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}";
    }
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;
    if (taxModel != null && taxModel.active == true) {
      if (taxModel.isFix == true) {
        taxAmount = double.parse(taxModel.value.toString());
      } else {
        taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.value!.toString())) / 100;
      }
    }
    return taxAmount;
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    return LanguageModel.fromJson(userMap);
  }

  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Text(message, style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 18, color: AppColors.darkGrey10)),
    );
  }

  static String timestampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String timestampToTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm aa').format(dateTime);
  }

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<String>> uploadParkingImage(List<String> images) async {
    var imageUrls = await Future.wait(images.map((image) =>
        uploadUserImageToFireStorage(File(image), "parkingImages/${FireStoreUtils.getCurrentUid()}", File(image).path.split("/").last)));
    return imageUrls;
  }

  static bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static Future<void> redirectCall({required String countryCode, required String phoneNumber}) async {
    final Uri url = Uri.parse("tel:$countryCode $phoneNumber");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${Constant.supportEmail.toString()}'.tr);
    }
  }

  static Future<DateTime?> selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.yellow04, // header background color
                onPrimary: AppColors.darkGrey10, // header text color
                onSurface: AppColors.darkGrey10, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGrey10, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(1900),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    return pickedDate;
  }

  static Future<TimeOfDay?> selectTime(context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dayPeriodColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected) ? AppColors.yellow04 : AppColors.yellow04.withOpacity(0.4)),
                dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                hourMinuteColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected) ? AppColors.yellow04 : AppColors.yellow04.withOpacity(0.4)),
              ),
              colorScheme: const ColorScheme.light(
                primary: AppColors.yellow04, // header background color
                onPrimary: AppColors.darkGrey10, // header text color
                onSurface: AppColors.darkGrey10, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGrey10, // button text color
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    return pickedTime;
  }
}
