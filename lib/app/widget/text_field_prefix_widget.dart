import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:owner_app/themes/app_colors.dart';
import 'package:owner_app/themes/app_them_data.dart';

// ignore: must_be_immutable
class TextFieldWidgetPrefix extends StatelessWidget {
  final String? title;
  final String hintText;
  String? titleFontFamily = AppThemData.medium;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? prefix;
  final bool? enable;
  final bool? readOnly;
  final int? maxLine;
  // ignore: prefer_typing_uninitialized_variables
  final validator;
  double? titleFontSize = 14;
  Color? titleColor = AppColors.darkGrey06;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldWidgetPrefix(
      {super.key,
      this.textInputType,
      this.enable,
      this.readOnly,
      this.prefix,
      this.maxLine,
      this.title,
      this.titleFontSize,
      this.inputFormatters,
      this.titleFontFamily,
      this.titleColor,
      required this.hintText,
      required this.controller,
      required this.onPress,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '', style: TextStyle(fontFamily: titleFontFamily, fontSize: titleFontSize, color: titleColor)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            readOnly: readOnly ?? false,
            onTap: onPress,
            validator: validator ?? (value) => value != null && value.isNotEmpty ? null : 'required'.tr,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            maxLines: maxLine ?? 1,
            inputFormatters: inputFormatters,
            style: const TextStyle(fontFamily: AppThemData.semiBold, fontSize: 14, color: AppColors.darkGrey10),
            decoration: InputDecoration(
                errorStyle: const TextStyle(fontFamily: AppThemData.regular, color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: prefix != null ? 0 : 10),
                prefixIcon: prefix,
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.yellow04),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                hintText: hintText.tr,
                hintStyle: const TextStyle(fontFamily: AppThemData.medium, fontSize: 16, color: AppColors.darkGrey04)),
          ),
        ],
      ),
    );
  }
}
