import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget onPress({Function? ontap, Widget? child, Key? key}) {
  return InkWell(
    key: key,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () {
      if (ontap != null) {
        ontap();
      }
    },
    child: child,
  );
}

Widget customButon({
  bool isIcon = false,
  String? btnText,
  Function? onTap,
  double? fontSize,
  String? icon,
}) {
  return onPress(
    ontap: () {
      if (onTap != null) {
        onTap();
      }
    },
    child: Stack(
      children: [
        Image.asset(
          "assets/icons/btn.png",
          width: Get.width,
          height: 8.h,
          fit: BoxFit.fill,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: .75.h),
              child: isIcon
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(icon!, height: 1.75.h),
                        SizedBox(width: 2.w),
                        text_widget(
                          btnText ?? '',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff113559),
                        ),
                      ],
                    )
                  : text_widget(
                      btnText ?? "",
                      fontSize: fontSize ?? 17.5.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff113559),
                    ),
            ),
          ),
        ),
      ],
    ),
  );
}
