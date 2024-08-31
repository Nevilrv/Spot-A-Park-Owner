import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/bank_details_model.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class BankDetailsScreenController extends GetxController {
  Rx<TextEditingController> accountHolderNameController = TextEditingController().obs;
  Rx<TextEditingController> accountNumberController = TextEditingController().obs;
  Rx<TextEditingController> swiftCodeController = TextEditingController().obs;
  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> branchCityNameController = TextEditingController().obs;
  Rx<TextEditingController> branchCountryNameController = TextEditingController().obs;

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getBankDetails();
    super.onInit();
  }

  getBankDetails() async {
    isLoading.value = true;
    await FireStoreUtils.getBankDetails().then((value) {
      if (value != null) {
        bankDetailsModel.value = value;
        accountHolderNameController.value.text = bankDetailsModel.value.holderName!;
        accountNumberController.value.text = bankDetailsModel.value.accountNumber!;
        swiftCodeController.value.text = bankDetailsModel.value.swiftCode!;
        bankNameController.value.text = bankDetailsModel.value.bankName!;
        branchCityNameController.value.text = bankDetailsModel.value.branchCity!;
        branchCountryNameController.value.text = bankDetailsModel.value.branchCountry!;
      }
    });
    isLoading.value = false;
  }

  saveBankDetails() async {
    if (accountHolderNameController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter holder name".tr);
    } else if (accountNumberController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter account number".tr);
    } else if (swiftCodeController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter SWIFT/IFSC number".tr);
    } else if (bankNameController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter bank name".tr);
    } else if (branchCityNameController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter branch city name".tr);
    } else if (branchCountryNameController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter branch country name".tr);
    } else {
      ShowToastDialog.showLoader("Please wait".tr);

      bankDetailsModel.value.ownerID = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = accountHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = accountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = branchCityNameController.value.text;
      bankDetailsModel.value.branchCountry = branchCountryNameController.value.text;

      await FireStoreUtils.updateBankDetails(bankDetailsModel.value).then((value) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Bank details update successfully".tr);
        Get.back();
      });
    }
  }
}
