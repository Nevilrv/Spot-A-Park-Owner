import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';

// ignore: must_be_immutable
class MobileNumberTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  String countryCode = '';
  String? titleFontFamily = AppThemData.medium;
  double? titleFontSize = 14;
  Color? titleColor = AppColors.darkGrey06;
  final Function() onPress;
  final bool? enabled;

  MobileNumberTextField({
    super.key,
    this.titleColor,
    this.titleFontSize,
    this.titleFontFamily,
    required this.controller,
    required this.countryCode,
    required this.onPress,
    required this.title,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: titleFontFamily,
              fontSize: titleFontSize,
              color: titleColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            validator: (value) => value != null && value.isNotEmpty ? null : 'Phone number required'.tr,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            style: const TextStyle(
              fontFamily: AppThemData.semiBold,
              color: AppColors.darkGrey10,
              fontSize: 14,
            ),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enabled ?? true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal:  5),
                prefixIcon: CountryCodePicker(
                  showFlag: false,padding: EdgeInsets.zero,
                  onChanged: (value) {
                    countryCode = value.dialCode.toString();
                  },
                  dialogTextStyle: const TextStyle(
                    fontFamily: AppThemData.regular,
                  ),
                  dialogBackgroundColor: AppColors.lightGrey02,
                  initialSelection: countryCode,
                  comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                  flagDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  textStyle: const TextStyle(fontFamily: AppThemData.medium, color: AppColors.darkGrey04, fontSize: 14),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.yellow04),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                hintText: "Enter Mobile Number".tr,
                hintStyle: const TextStyle(fontSize: 16, color: AppColors.darkGrey04, fontFamily: AppThemData.medium)),
          ),
        ],
      ),
    );
  }
}
