// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:owner_app/app/models/wallet_transaction_model.dart';
import 'package:owner_app/app/models/withdraw_model.dart';
import 'package:owner_app/app/routes/app_pages.dart';
import 'package:owner_app/app/widget/text_field_prefix_widget.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:owner_app/constant/show_toast_dialogue.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';
import 'package:owner_app/themes/common_ui.dart';
import 'package:owner_app/themes/screen_size.dart';
import 'package:owner_app/utils/fire_store_utils.dart';

import '../../../../themes/button_theme.dart';
import '../controllers/wallet_screen_controller.dart';

class WalletScreenView extends StatelessWidget {
  const WalletScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WalletScreenController>(
        init: WalletScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey02,
            appBar: UiInterface().customAppBar(context, "Wallet Transactions".tr, isBack: true, backgroundColor: AppColors.lightGrey02),
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Monitor your wallet activity effortlessly. View transactions, add funds, and stay in control of your parking payments'
                              .tr,
                          style: const TextStyle(
                            height: 1.2,
                            color: AppColors.lightGrey10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Container(
                          width: Responsive.width(100, context),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/credit_card_bg.png",
                                  ),
                                  fit: BoxFit.fitWidth)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  "Total Amount".tr,
                                  style: const TextStyle(fontSize: 12, color: AppColors.blue03, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  Constant.amountShow(amount: controller.ownerModel.value.walletAmount.toString()),
                                  style: const TextStyle(fontSize: 32, color: AppColors.blue01, fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  "Minimum Withdrawal will be a ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal)}",
                                  style: const TextStyle(fontSize: 12, color: AppColors.blue03, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                ButtonThem.buildButton(
                                  btnHeight: 48,
                                  txtSize: 16,
                                  context,
                                  title: "Withdrawal".tr,
                                  txtColor: AppColors.darkGrey10,
                                  bgColor: AppColors.yellow04,
                                  onPress: () async {
                                    if (double.parse(controller.ownerModel.value.walletAmount.toString()) <=
                                        double.parse(Constant.minimumAmountToWithdrawal.toString())) {
                                      ShowToastDialog.showToast("Insufficient balance".tr);
                                    } else {
                                      ShowToastDialog.showLoader("Please wait..".tr);
                                      controller.getProfileData();
                                      await FireStoreUtils.bankDetailsIsAvailable().then((value) {
                                        ShowToastDialog.closeLoader();
                                        if (value == true) {
                                          withdrawalBottomSheet(context, controller);
                                        } else {
                                          ShowToastDialog.showToast("Your bank details is not available.Please add bank details".tr);
                                          Get.toNamed(Routes.BANK_DETAILS_SCREEN);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.lightGrey06, borderRadius: BorderRadius.circular(40)),
                                child: TabBar(
                                  dividerColor: Colors.transparent,
                                  onTap: (value) {
                                    controller.selectedTabIndex.value = value;
                                  },
                                  labelStyle: const TextStyle(color: Colors.black, fontFamily: AppThemData.medium),
                                  unselectedLabelStyle: const TextStyle(color: AppColors.darkGrey04, fontFamily: AppThemData.regular),
                                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.yellow04),
                                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  labelColor: Colors.black,
                                  unselectedLabelColor: AppColors.darkGrey04,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    Tab(
                                      text: "Transaction History".tr,
                                    ),
                                    Tab(
                                      text: "Withdrawal History".tr,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TabBarView(children: [
                                    controller.transactionList.isEmpty
                                        ? Constant.showEmptyView(message: "Transaction not found".tr)
                                        : ListView.builder(
                                            itemCount: controller.transactionList.length,
                                            itemBuilder: (context, index) {
                                              WalletTransactionModel walletTransactionModel = controller.transactionList[index];
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            padding: const EdgeInsets.all(12),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: AppColors.darkGrey01),
                                                                borderRadius: BorderRadiusDirectional.circular(30)),
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_credit_card.svg",
                                                              color: walletTransactionModel.isCredit == true
                                                                  ? AppColors.green04
                                                                  : AppColors.red04,
                                                            )),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${walletTransactionModel.note}',
                                                                      style: const TextStyle(
                                                                          color: AppColors.darkGrey07,
                                                                          fontFamily: AppThemData.medium,
                                                                          fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    Constant.amountShow(amount: walletTransactionModel.amount),
                                                                    style: const TextStyle(
                                                                        color: AppColors.darkGrey07,
                                                                        fontFamily: AppThemData.medium,
                                                                        fontSize: 16),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      Constant.timestampToDate(walletTransactionModel.createdDate!),
                                                                      style: const TextStyle(
                                                                          color: AppColors.darkGrey03,
                                                                          fontFamily: AppThemData.medium,
                                                                          fontSize: 12),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    'Success',
                                                                    style: TextStyle(
                                                                        color: AppColors.green04,
                                                                        fontFamily: AppThemData.medium,
                                                                        fontSize: 12),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                    FutureBuilder<List<WithdrawModel>?>(
                                        future: FireStoreUtils.getWithDrawRequest(),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Constant.loader();
                                            case ConnectionState.done:
                                              if (snapshot.hasError) {
                                                return Text(snapshot.error.toString());
                                              } else {
                                                return snapshot.data!.isEmpty
                                                    ? Constant.showEmptyView(message: "No withdrawal history found".tr)
                                                    : ListView.builder(
                                                        itemCount: snapshot.data!.length,
                                                        itemBuilder: (context, index) {
                                                          WithdrawModel withdrawTransactionModel = snapshot.data![index];
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                        padding: const EdgeInsets.all(12),
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(color: AppColors.darkGrey01),
                                                                            borderRadius: BorderRadiusDirectional.circular(30)),
                                                                        child: SvgPicture.asset(
                                                                          "assets/icons/ic_credit_card.svg",
                                                                          color: withdrawTransactionModel.paymentStatus == Constant.pending
                                                                              ? AppColors.red04
                                                                              : AppColors.green04,
                                                                        )),
                                                                    const SizedBox(width: 10),
                                                                    Expanded(
                                                                      child: Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  '${withdrawTransactionModel.note}',
                                                                                  style: const TextStyle(
                                                                                      color: AppColors.darkGrey07,
                                                                                      fontFamily: AppThemData.medium,
                                                                                      fontSize: 16),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                Constant.amountShow(
                                                                                    amount: withdrawTransactionModel.amount),
                                                                                style: const TextStyle(
                                                                                    color: AppColors.darkGrey07,
                                                                                    fontFamily: AppThemData.medium,
                                                                                    fontSize: 16),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  Constant.timestampToDate(
                                                                                      withdrawTransactionModel.createdDate!),
                                                                                  style: const TextStyle(
                                                                                      color: AppColors.darkGrey03,
                                                                                      fontFamily: AppThemData.medium,
                                                                                      fontSize: 12),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                withdrawTransactionModel.paymentStatus == Constant.pending
                                                                                    ? "Pending"
                                                                                    : withdrawTransactionModel.paymentStatus ==
                                                                                            Constant.rejected
                                                                                        ? "Rejected"
                                                                                        : 'Success',
                                                                                style: TextStyle(
                                                                                    color: (withdrawTransactionModel.paymentStatus ==
                                                                                                Constant.pending ||
                                                                                            withdrawTransactionModel.paymentStatus ==
                                                                                                Constant.rejected)
                                                                                        ? AppColors.red04
                                                                                        : AppColors.green04,
                                                                                    fontFamily: AppThemData.medium,
                                                                                    fontSize: 12),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                              }
                                            default:
                                              return Text('Error'.tr);
                                          }
                                        })
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  withdrawalBottomSheet(BuildContext context, WalletScreenController controller) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.7,
              child: StatefulBuilder(builder: (context1, setState) {
                return Obx(
                  () => Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                              width: 134,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: ShapeDecoration(
                                color: AppColors.darkGrey10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Withdrawal'.tr,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: AppThemData.medium,
                                            color: AppColors.darkGrey10,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: AppColors.darkGrey10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(color: AppColors.darkGrey03, thickness: 1),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextFieldWidgetPrefix(
                                      title: 'Amount'.tr,
                                      titleColor: AppColors.darkGrey10,
                                      titleFontSize: 16,
                                      titleFontFamily: AppThemData.medium,
                                      hintText: 'Enter Amount'.tr,
                                      controller: controller.withdrawalAmountController.value,
                                      textInputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                      ],
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(Constant.currencyModel!.symbol.toString(),
                                            style: const TextStyle(fontSize: 20, color: AppColors.darkGrey06)),
                                      ),
                                      onPress: () {}),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextFieldWidgetPrefix(
                                    title: 'Note'.tr,
                                    onPress: () {},
                                    controller: controller.noteController.value,
                                    hintText: 'Enter Note'.tr,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: AppColors.darkGrey10,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Maximum withdrawal amount will be a ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}"
                                              .tr,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey09),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bank Details'.tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppThemData.medium,
                                          color: AppColors.darkGrey07,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset("assets/icons/ic_bank_image.svg", height: 45, width: 45),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Bank Name : ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: AppThemData.medium,
                                                        color: AppColors.darkGrey07,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.bankDetailsModel.value.bankName.toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: AppThemData.bold,
                                                          color: AppColors.darkGrey07,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "A/c Number : ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: AppThemData.medium,
                                                        color: AppColors.darkGrey07,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.bankDetailsModel.value.accountNumber.toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: AppThemData.bold,
                                                          color: AppColors.darkGrey07,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "IFSC Code : ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: AppThemData.medium,
                                                        color: AppColors.darkGrey07,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.bankDetailsModel.value.swiftCode.toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: AppThemData.bold,
                                                          color: AppColors.darkGrey07,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    bottomNavigationBar: Container(
                      color: AppColors.lightGrey02,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ButtonThem.buildButton(
                          context,
                          txtColor: AppColors.lightGrey01,
                          bgColor: AppColors.darkGrey10,
                          title: "Withdraw".tr,
                          onPress: () async {
                            if (controller.withdrawalAmountController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter amount");
                            } else if (double.parse(controller.ownerModel.value.walletAmount.toString()) <
                                double.parse(controller.withdrawalAmountController.value.text)) {
                              ShowToastDialog.showToast("Insufficient balance".tr);
                            } else if (double.parse(Constant.minimumAmountToWithdrawal) >
                                double.parse(controller.withdrawalAmountController.value.text)) {
                              ShowToastDialog.showToast(
                                  "Withdraw amount must be greater or equal to ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}"
                                      .tr);
                            } else {
                              ShowToastDialog.showLoader("Please wait".tr);
                              WithdrawModel withdrawModel = WithdrawModel();
                              withdrawModel.id = Constant.getUuid();
                              withdrawModel.ownerId = FireStoreUtils.getCurrentUid();
                              withdrawModel.paymentStatus = Constant.pending;
                              withdrawModel.amount = controller.withdrawalAmountController.value.text;
                              withdrawModel.note = controller.noteController.value.text;
                              withdrawModel.createdDate = Timestamp.now();

                              await FireStoreUtils.updateUserWallet(amount: "-${controller.withdrawalAmountController.value.text}");

                              await FireStoreUtils.setWithdrawRequest(withdrawModel).then((value) {
                                controller.getProfileData();
                                controller.withdrawalAmountController.value.clear();
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Request sent to admin".tr);
                                Get.back();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ));
  }
}
