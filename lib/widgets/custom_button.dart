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
  String? icon,
}) {
  return Center(
    child: onPress(
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
            fit: BoxFit.fill,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    height: 6.h,
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Column(
                      children: [
                        Spacer(),
                        isIcon
                            ? Row(
                                children: [
                                  Spacer(),
                                  Image.asset(icon!, height: 2.8.h),
                                  SizedBox(width: 1.6.w),
                                  text_widget(
                                    btnText ?? '',
                                    fontSize: 17.6.sp,
                                    // textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff113559),
                                  ),
                                  Spacer(),
                                ],
                              )
                            : text_widget(
                                btnText ?? "",
                                fontSize: 17.6.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff113559),
                              ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class customActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color borderColor;

  const customActionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.borderColor,
  });

  @override
  Widget build(_) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6D54A), Color(0xFFE5BF2F)],
          ),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.45),
              blurRadius: 28,
              spreadRadius: 12,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: borderColor.withValues(alpha: 0.8),
              blurRadius: 16,
              spreadRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F3B5B),
            ),
          ),
        ),
      ),
    );
  }
}
