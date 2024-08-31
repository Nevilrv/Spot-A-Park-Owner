import 'package:get/get.dart';
import 'package:owner_app/app/models/contact_us_model.dart';
import '../../../../utils/fire_store_utils.dart';

class ContactUsScreenController extends GetxController {
  Rx<ContactUsModel> contactUsModel = ContactUsModel().obs;
  RxBool isLoading = true.obs;



  @override
  void onInit() {
    getContactUs();
    super.onInit();
  }

  getContactUs() {
    FireStoreUtils.getContactUsInformation().then((value) {
      if (value != null) {
        contactUsModel.value = value;
        isLoading.value = false;
      }
    });
  }
}
