// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;

  RxString countryCode = "+91".obs;

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  sendCode() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCode.value + phoneNumberController.value.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("invalid_phone_number".tr);
        } else {
          ShowToastDialog.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        Get.toNamed(Routes.OTP_SCREEN, arguments: {
          "countryCode": countryCode.value,
          "phoneNumber": phoneNumberController.value.text,
          "verificationId": verificationId,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("multiple_time_request".tr);
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        return null;
      });

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
    // Trigger the authentication flow
  }

  loginWithGoogle() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    await signInWithGoogle().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          OwnerModel ownerModel = OwnerModel();
          ownerModel.id = value.user!.uid;
          ownerModel.email = value.user!.email;
          ownerModel.fullName = value.user!.displayName;
          ownerModel.profilePic = value.user!.photoURL;
          ownerModel.loginType = Constant.googleLoginType;

          ShowToastDialog.closeLoader();
          Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {"ownerModel": ownerModel});
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              OwnerModel? ownerModel = await FireStoreUtils.getUserProfile(value.user!.uid);
              if (ownerModel != null) {
                if (ownerModel.active == true) {
                  Get.toNamed(Routes.DASHBOARD_SCREEN);
                }
                else{
                  ShowToastDialog.showToast("Unable to Log In?  Please Contact the Admin for Assistance");
                }
              }
            } else {
              OwnerModel ownerModel = OwnerModel();
              ownerModel.id = value.user!.uid;
              ownerModel.email = value.user!.email;
              ownerModel.fullName = value.user!.displayName;
              ownerModel.profilePic = value.user!.photoURL;
              ownerModel.loginType = Constant.googleLoginType;

              Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {"ownerModel": ownerModel});
            }
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
        nonce: nonce,
      ).catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
      });

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          OwnerModel ownerModel = OwnerModel();
          ownerModel.id = value.user!.uid;
          ownerModel.email = value.user!.email;
          ownerModel.profilePic = value.user!.photoURL;
          ownerModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {"ownerModel": ownerModel});
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              OwnerModel? ownerModel = await FireStoreUtils.getUserProfile(value.user!.uid);
              if (ownerModel != null) {
                if (ownerModel.active == true) {
                  Get.toNamed(Routes.DASHBOARD_SCREEN);
                }
                else{
                  ShowToastDialog.showToast("Unable to Log In?  Please Contact the Admin for Assistance");
                }
              }
            } else {
              OwnerModel ownerModel = OwnerModel();
              ownerModel.id = value.user!.uid;
              ownerModel.email = value.user!.email;
              ownerModel.profilePic = value.user!.photoURL;
              ownerModel.loginType = Constant.googleLoginType;

              Get.offNamed(Routes.INFORMATION_SCREEN, arguments: {"ownerModel": ownerModel});
            }
          });
        }
      }
    });
  }
}
