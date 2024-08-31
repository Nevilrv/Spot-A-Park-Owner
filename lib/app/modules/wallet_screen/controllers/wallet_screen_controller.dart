import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/bank_details_model.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/models/payment_method_model.dart';
import 'package:owner_app/app/models/wallet_transaction_model.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

class WalletScreenController extends GetxController {
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxBool isLoading = true.obs;
  RxString selectedPaymentMethod = "".obs;
  RxInt selectedTabIndex = 0.obs;

  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> withdrawalAmountController = TextEditingController().obs;
  Rx<TextEditingController> noteController = TextEditingController(text: "Withdrawal").obs;

  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;

  RxList transactionList = <WalletTransactionModel>[].obs;

  @override
  void onInit() {
    getTraction();
    super.onInit();
  }

  getProfileData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        ownerModel.value = value;
      }
    });
    getBankDetailsData();
    isLoading.value = false;
  }

  getBankDetailsData() async {
    await FireStoreUtils.getBankDetails().then((value) {
      if (value != null) {
        bankDetailsModel.value = value;
      }
    });
  }

  getTraction() async {
    await FireStoreUtils.getWalletTransaction().then((value) {
      if (value != null) {
        transactionList.value = value;
      }
    });
    await getProfileData();
  }
}
