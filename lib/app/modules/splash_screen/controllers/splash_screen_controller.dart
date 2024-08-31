import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:owner_app/app/models/currency_model.dart';
import 'package:owner_app/app/models/language_model.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/services/localization_service.dart';
import 'package:owner_app/utils/fire_store_utils.dart';
import 'package:owner_app/utils/notification_service.dart';
import 'package:owner_app/utils/preferences.dart';

class SplashScreenController extends GetxController {
  @override
  Future<void> onInit() async {
    await getCurrentCurrency();
    notificationInit();
    checkLanguage();
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  getCurrentCurrency() async {
    await FireStoreUtils.getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel =
            CurrencyModel(id: "", code: "USD", decimalDigits: 2, enable: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
    await FireStoreUtils.getSettings();
  }

  redirectScreen() async {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
      Get.offAllNamed(Routes.INTRO_SCREEN);
    } else {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
          if (value!.active == true) {
            Get.offAllNamed(Routes.DASHBOARD_SCREEN);
          } else {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            Get.offAllNamed(Routes.WELCOME_SCREEN);
          }
        });
      } else {
        Get.offAllNamed(Routes.WELCOME_SCREEN);
      }
    }
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            OwnerModel ownerModel = value;
            ownerModel.fcmToken = token;
            FireStoreUtils.updateUser(ownerModel);
          }
        });
      }
    });
  }

  checkLanguage() {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    } else {
      LanguageModel languageModel = LanguageModel(id: "C7xXcFomC9dLv5ENpDQa", code: "en", name: "English");
      Preferences.setString(Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
    }
  }
}
