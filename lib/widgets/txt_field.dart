import 'package:flutter/material.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget textFieldWithPrefixSuffuxIconAndHintText(
  String hintText, {
  suffixIcon,
  TextEditingController? controller,
  int line = 1,
  bool isSuffix = false,
  bool enable = true,
  TextInputType textInputType = TextInputType.text,
  double? radius,
  bool isTextSuffix = false,
  suffText,
  fillColor,
  bColor,
  mainTxtColor,
  pColor,
  hintColor,
  Function? onChange,
  bool obsecure = false,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return TextField(
        maxLines: line,
        keyboardType: textInputType,
        onChanged: (value) {
          if (onChange != null) {
            onChange();
          }
        },
        enabled: enable,
        obscureText: obsecure,
        cursorColor: Colors.grey.shade300,
        controller: controller,
        style: TextStyle(
          color: mainTxtColor ?? Colors.black54,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w400,
            color: hintColor ?? Colors.black54,
          ),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: isTextSuffix
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: text_widget(
                    suffText,
                    fontSize: 14.6.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : suffixIcon.toString().contains("assets")
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: onPress(
                    ontap: () {},
                    child: Image.asset(suffixIcon, height: 3.h),
                  ),
                )
              : isSuffix
              ? Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: onPress(
                    ontap: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    child: Icon(
                      suffixIcon ?? obsecure
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      size: 2.3.h,
                      color: Color(0xffACB5BB),
                    ),
                  ),
                )
              : const SizedBox(),
          filled: true,
          fillColor: fillColor ?? Color(0xffF7F7F7),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(
              color: bColor ?? Colors.transparent,
              width: 1.4,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(
              color: bColor ?? Color(0xffE6DCCD),
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(color: MyColors.primary, width: 1.4),
          ),
        ),
      );
    },
  );
}
