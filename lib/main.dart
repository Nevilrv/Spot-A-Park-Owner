import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:owner_app/firebase_options.dart';
import 'package:owner_app/services/localization_service.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/utils/preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Preferences.initPref();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.darkGrey10,
  ));
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        CountryLocalizations.delegate,
      ],
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.locale,
      translations: LocalizationService(),
      builder: EasyLoading.init(),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    ),
  );
}
