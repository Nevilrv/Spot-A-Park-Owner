import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldWidgetSuffix extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? suffix;
  final bool? enable;
  final TextInputType? textInputType;

  const TextFieldWidgetSuffix(
      {super.key, this.textInputType, this.enable, this.suffix, this.title, required this.hintText, required this.controller, required this.onPress});

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
                Text(title ?? '', style: const TextStyle()),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            validator: (value) => value != null && value.isNotEmpty ? null : 'phone_number_required'.tr,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                suffixIcon: suffix,
                disabledBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black12, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black12, width: 1),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black12, width: 1),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black12, width: 1),
                ),
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black12, width: 1),
                ),
                hintText: hintText.tr,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
