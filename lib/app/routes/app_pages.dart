import 'package:get/get.dart';

import '../modules/add_parking_screen/bindings/add_parking_screen_binding.dart';
import '../modules/add_parking_screen/views/add_parking_screen_view.dart';
import '../modules/add_watchman_screen/bindings/add_watchman_screen_binding.dart';
import '../modules/add_watchman_screen/views/add_watchman_screen_view.dart';
import '../modules/approve_number_plate_screen/bindings/approve_number_plate_screen_binding.dart';
import '../modules/approve_number_plate_screen/views/approve_number_plate_screen_view.dart';
import '../modules/bank_details_screen/bindings/bank_details_screen_binding.dart';
import '../modules/bank_details_screen/views/bank_details_screen_view.dart';
import '../modules/booking_canceled_screen/bindings/booking_canceled_screen_binding.dart';
import '../modules/booking_canceled_screen/views/booking_canceled_screen_view.dart';
import '../modules/booking_completed_screen/bindings/booking_completed_screen_binding.dart';
import '../modules/booking_completed_screen/views/booking_completed_screen_view.dart';
import '../modules/booking_screen/bindings/booking_screen_binding.dart';
import '../modules/booking_screen/views/booking_screen_view.dart';
import '../modules/booking_summary_screen/bindings/booking_summary_screen_binding.dart';
import '../modules/booking_summary_screen/views/booking_summary_screen_view.dart';
import '../modules/contact_us_screen/bindings/contact_us_screen_binding.dart';
import '../modules/contact_us_screen/views/contact_us_screen_view.dart';
import '../modules/dashboard_screen/bindings/dashboard_screen_binding.dart';
import '../modules/dashboard_screen/views/dashboard_screen_view.dart';
import '../modules/edit_profile_screen/bindings/edit_profile_screen_binding.dart';
import '../modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/information_screen/bindings/information_screen_binding.dart';
import '../modules/information_screen/views/information_screen_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/language_screen/bindings/language_screen_binding.dart';
import '../modules/language_screen/views/language_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/ongoing_screen/bindings/ongoing_screen_binding.dart';
import '../modules/ongoing_screen/views/ongoing_screen_view.dart';
import '../modules/otp_screen/bindings/otp_screen_binding.dart';
import '../modules/otp_screen/views/otp_screen_view.dart';
import '../modules/parking_details_screen/bindings/parking_details_screen_binding.dart';
import '../modules/parking_details_screen/views/parking_details_screen_view.dart';
import '../modules/parking_screen/bindings/parking_screen_binding.dart';
import '../modules/parking_screen/views/parking_screen_view.dart';
import '../modules/placed_screen/bindings/placed_screen_binding.dart';
import '../modules/placed_screen/views/placed_screen_view.dart';
import '../modules/profile_screen/bindings/profile_screen_binding.dart';
import '../modules/profile_screen/views/profile_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/wallet_screen/bindings/wallet_screen_binding.dart';
import '../modules/wallet_screen/views/wallet_screen_view.dart';
import '../modules/watchman_screen/bindings/watchman_screen_binding.dart';
import '../modules/watchman_screen/views/watchman_screen_view.dart';
import '../modules/welcome_screen/bindings/welcome_screen_binding.dart';
import '../modules/welcome_screen/views/welcome_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_SCREEN,
      page: () => const WelcomeScreenView(),
      binding: WelcomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.INFORMATION_SCREEN,
      page: () => const InformationScreenView(),
      binding: InformationScreenBinding(),
    ),
    GetPage(
      name: _Paths.OTP_SCREEN,
      page: () => const OtpScreenView(),
      binding: OtpScreenBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_SCREEN,
      page: () => const DashboardScreenView(),
      binding: DashboardScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PARKING_SCREEN,
      page: () => const AddParkingScreenView(),
      binding: AddParkingScreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_WATCHMAN_SCREEN,
      page: () => const AddWatchmanScreenView(),
      binding: AddWatchmanScreenBinding(),
    ),
    GetPage(
      name: _Paths.WATCHMAN_SCREEN,
      page: () => const WatchmanScreenView(),
      binding: WatchmanScreenBinding(),
    ),
    GetPage(
      name: _Paths.PARKING_SCREEN,
      page: () => const ParkingScreenView(),
      binding: ParkingScreenBinding(),
    ),
    GetPage(
        name: _Paths.BOOKING_SCREEN,
        page: () => const BookingScreenView(),
        binding: BookingScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
      name: _Paths.BOOKING_SUMMARY_SCREEN,
      page: () => const BookingSummaryScreenView(),
      binding: BookingSummaryScreenBinding(),
    ),
    GetPage(
      name: _Paths.PARKING_DETAILS_SCREEN,
      page: () => const ParkingDetailsScreenView(),
      binding: ParkingDetailsScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.PLACED_SCREEN,
      page: () => const PlacedScreenView(),
      binding: PlacedScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONGOING_SCREEN,
      page: () => const OngoingScreenView(),
      binding: OngoingScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_COMPLETED_SCREEN,
      page: () => const BookingCompletedScreenView(),
      binding: BookingCompletedScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_CANCELED_SCREEN,
      page: () => const BookingCanceledScreenView(),
      binding: BookingCanceledScreenBinding(),
    ),
    GetPage(
        name: _Paths.WALLET_SCREEN,
        page: () => const WalletScreenView(),
        binding: WalletScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.EDIT_PROFILE_SCREEN,
        page: () => const EditProfileScreenView(),
        binding: EditProfileScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.BANK_DETAILS_SCREEN,
        page: () => const BankDetailsScreenView(),
        binding: BankDetailsScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.LANGUAGE_SCREEN,
        page: () => const LanguageScreenView(),
        binding: LanguageScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
      name: _Paths.APPROVE_NUMBER_PLATE_SCREEN,
      page: () => const ApproveNumberPlateScreenView(),
      binding: ApproveNumberPlateScreenBinding(),
    ),
    GetPage(
        name: _Paths.CONTACT_US_SCREEN,
        page: () => const ContactUsScreenView(),
        binding: ContactUsScreenBinding(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 200)),
  ];
}
