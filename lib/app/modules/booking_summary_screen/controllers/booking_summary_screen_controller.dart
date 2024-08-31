import 'package:get/get.dart';
import 'package:owner_app/app/models/booking_model.dart';
import 'package:owner_app/app/models/customer_model.dart';
import 'package:owner_app/constant/constant.dart';

class BookingSummaryScreenController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<CustomerModel> customerModel = CustomerModel().obs;
  RxDouble couponAmount = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArguments();
    super.onInit();
  }

  getArguments() async {
    dynamic argument = Get.arguments;
    if (argument != null) {
      bookingModel.value = argument['bookingModel'];
      customerModel.value = argument['customerModel'];
    }
  }

  applyCoupon() async {
    if (bookingModel.value.coupon != null) {
      if (bookingModel.value.coupon!.id != null) {
        if (bookingModel.value.coupon!.isFix == true) {
          couponAmount.value = double.parse(bookingModel.value.coupon!.amount.toString());
        } else {
          couponAmount.value =
              double.parse(bookingModel.value.subTotal.toString()) * double.parse(bookingModel.value.coupon!.amount.toString()) / 100;
        }
      }
    }
  }

  double calculateAmount() {
    applyCoupon();
    RxString taxAmount = "0.0".obs;
    if (bookingModel.value.taxList != null) {
      for (var element in bookingModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant.calculateTax(
                    amount: (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())).toString(),
                    taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingModel.value.subTotal.toString()) - double.parse(couponAmount.toString())) + double.parse(taxAmount.value);
  }
}
