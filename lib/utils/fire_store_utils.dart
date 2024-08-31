import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:owner_app/app/models/bank_details_model.dart';
import 'package:owner_app/app/models/booking_model.dart';
import 'package:owner_app/app/models/contact_us_model.dart';
import 'package:owner_app/app/models/currency_model.dart';
import 'package:owner_app/app/models/customer_model.dart';
import 'package:owner_app/app/models/language_model.dart';
import 'package:owner_app/app/models/owner_model.dart';
import 'package:owner_app/app/models/parking_facilities_model.dart';
import 'package:owner_app/app/models/parking_model.dart';
import 'package:owner_app/app/models/payment_method_model.dart';
import 'package:owner_app/app/models/wallet_transaction_model.dart';
import 'package:owner_app/app/models/watchman_model.dart';
import 'package:owner_app/app/models/withdraw_model.dart';
import 'package:owner_app/constant/collection_name.dart';
import 'package:owner_app/constant/constant.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.owners).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static getSettings() async {
    await fireStore.collection(CollectionName.settings).doc("constant").get().then((value) {
      if (value.exists) {
        Constant.minimumAmountToWithdrawal = value.data()!["minimum_amount_withdraw"];
        Constant.termsAndConditions = value.data()!["termsAndConditions"];
        Constant.privacyPolicy = value.data()!["privacyPolicy"];
        Constant.supportEmail = value.data()!["supportEmail"];
        Constant.mapAPIKey = value.data()!["googleMapKey"] ?? "";
        Constant.plateRecognizerApiToken = value.data()!["plateRecognizerApiToken"];
        Constant.mapAPIKey = value.data()!["googleMapKey"] ?? "";
      }
    });
  }

  static Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore.collection(CollectionName.settings).doc("payment").get().then((value) {
      paymentModel = PaymentModel.fromJson(value.data()!);
    });
    return paymentModel;
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.walletTransaction)
        .doc(walletTransactionModel.id)
        .set(walletTransactionModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> updateUserWallet({required String amount}) async {
    bool isAdded = false;
    await getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
      if (value != null) {
        OwnerModel ownerModel = value;
        ownerModel.walletAmount = (double.parse(ownerModel.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(ownerModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModel = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WalletTransactionModel taxModel = WalletTransactionModel.fromJson(element.data());
        walletTransactionModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModel;
  }

  static Future<OwnerModel?> getUserProfile(String uuid) async {
    OwnerModel? ownerModel;

    await fireStore.collection(CollectionName.owners).doc(uuid).get().then((value) {
      if (value.exists) {
        ownerModel = OwnerModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      ownerModel = null;
    });
    return ownerModel;
  }

  static Future<bool> deleteUser() async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.owners).doc(getCurrentUid()).delete().then((value) {
      isDelete = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isDelete = false;
    });
    return isDelete;
  }

  static Future<ContactUsModel?> getContactUsInformation() async {
    ContactUsModel? contactUsModel;
    await fireStore.collection(CollectionName.settings).doc('contact_us').get().then((value) {
      contactUsModel = ContactUsModel.fromJson(value.data()!);
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return contactUsModel;
  }

  static Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore.collection(CollectionName.currencies).where("active", isEqualTo: true).get().then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  static Future<bool> updateBooking(BookingModel bookingModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.bookParkingOrder).doc(bookingModel.id).set(bookingModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> updateUser(OwnerModel ownerModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.owners).doc(ownerModel.id).set(ownerModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> updateWatchManProfile(WatchManModel watchManModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.watchMans).doc(watchManModel.id).set(watchManModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<WatchManModel>?> getWatchManProfiles() async {
    List<WatchManModel> watchManModelList = [];

    await fireStore.collection(CollectionName.watchMans).where("ownerId", isEqualTo: getCurrentUid()).get().then((value) {
      for (var element in value.docs) {
        WatchManModel watchManModel = WatchManModel.fromJson(element.data());
        watchManModelList.add(watchManModel);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return watchManModelList;
  }

  static Future<WatchManModel?> getWatchmanDetail(String id) async {
    WatchManModel? watchManModel;

    await fireStore.collection(CollectionName.watchMans).doc(id).get().then((value) {
      watchManModel = WatchManModel.fromJson(value.data()!);
    }).catchError((error) {
      return null;
    });
    return watchManModel;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    await fireStore.collection(CollectionName.languages).where("active", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        LanguageModel languageModel = LanguageModel.fromJson(element.data());
        languageList.add(languageModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return languageList;
  }

  static Future<List<ParkingFacilitiesModel>> getParkingFacilities() async {
    List<ParkingFacilitiesModel> parkingFacilitiesList = [];
    await fireStore.collection(CollectionName.facilities).where("active", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ParkingFacilitiesModel parkingFacilitiesModel = ParkingFacilitiesModel.fromJson(element.data());
        parkingFacilitiesList.add(parkingFacilitiesModel);
      }
    }).catchError((error) {
      log("Faliled To get Facilities");
    });
    return parkingFacilitiesList;
  }

  static Future addParkingDetails(ParkingModel parkingModel) async {
    await fireStore.collection(CollectionName.parkings).doc(parkingModel.id).set(parkingModel.toJson()).catchError((error) {
      log("Failed to update user: $error");
      return null;
    });
    return null;
  }

  static Future<List<ParkingModel>?> getMyParkingList() async {
    List<ParkingModel> parkingModelList = [];
    await fireStore.collection(CollectionName.parkings).where("ownerId", isEqualTo: getCurrentUid()).get().then((value) {
      for (var element in value.docs) {
        ParkingModel parkingModel = ParkingModel.fromJson(element.data());
        parkingModelList.add(parkingModel);
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return parkingModelList;
  }

  static Future<List<BookingModel>?> getBookParkingOrderList(String parkingId) async {
    List<BookingModel> bookingModelList = [];
    await fireStore.collection(CollectionName.bookParkingOrder).where("parkingId", isEqualTo: parkingId).get().then((value) {
      for (var element in value.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data());
        bookingModelList.add(bookingModel);
      }
    }).catchError((error) {
      log("Failed to get data: $error");
      return null;
    });
    return bookingModelList;
  }

  static Future<ParkingModel?> getOwnerParkingDetail(String id) async {
    ParkingModel? parkingModel;

    await fireStore.collection(CollectionName.parkings).doc(id).get().then((value) {
      parkingModel = ParkingModel.fromJson(value.data()!);
    }).catchError((error) {
      return null;
    });
    return parkingModel;
  }

  static Future<CustomerModel?> getCustomerByCustomerID(String id) async {
    CustomerModel? customerModel;

    await fireStore.collection(CollectionName.customers).doc(id).get().then((value) {
      customerModel = CustomerModel.fromJson(value.data()!);
    }).catchError((error) {
      return null;
    });
    return customerModel;
  }

  static Future<BankDetailsModel?> getBankDetails() async {
    BankDetailsModel? bankDetailsModel;
    await fireStore.collection(CollectionName.bankDetails).doc(FireStoreUtils.getCurrentUid()).get().then((value) {
      if (value.data() != null) {
        bankDetailsModel = BankDetailsModel.fromJson(value.data()!);
      }
    });
    return bankDetailsModel;
  }

  static Future<bool?> updateBankDetails(BankDetailsModel bankDetailsModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.bankDetails).doc(bankDetailsModel.ownerID).set(bankDetailsModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> bankDetailsIsAvailable() async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.bankDetails).doc(FireStoreUtils.getCurrentUid()).get().then((value) {
      if (value.exists) {
        isAdded = true;
      } else {
        isAdded = false;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> setWithdrawRequest(WithdrawModel withdrawModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.withdrawalHistory).doc(withdrawModel.id).set(withdrawModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<WithdrawModel>> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];
    await fireStore
        .collection(CollectionName.withdrawalHistory)
        .where('ownerId', isEqualTo: getCurrentUid())
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WithdrawModel documentModel = WithdrawModel.fromJson(element.data());
        withdrawalList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return withdrawalList;
  }

  static Future<void> deleteMyParkingList() async {
    final collection = await fireStore.collection(CollectionName.parkings).where("ownerId", isEqualTo: getCurrentUid()).get();
    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    return batch.commit();
  }

  static Future<void> deleteWatchManList() async {
    final collection = await fireStore.collection(CollectionName.watchMans).where("ownerId", isEqualTo: getCurrentUid()).get();
    final batch = FirebaseFirestore.instance.batch();

    for (var element in collection.docs) {
      batch.delete(element.reference);
    }
    return batch.commit();
  }
}
