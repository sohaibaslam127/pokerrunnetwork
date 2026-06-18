import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showPopup(
  BuildContext context,
  String title,
  String button1,
  String button2,
  Function() button1Action,
  Function() button2Action,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: text_widget(
                      title.capitalize!,
                      textAlign: TextAlign.center,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 80.w,
                  height: 10.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 2.5.w,
                        child: onPress(
                          ontap: button1Action,
                          child: Image.asset(
                            button1,
                            fit: BoxFit.fill,
                            width: 40.w,
                            height: 10.h,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2.5.w,
                        child: onPress(
                          ontap: button2Action,
                          child: Image.asset(
                            button2,
                            fit: BoxFit.fill,
                            width: 40.w,
                            height: 10.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CustomPopups {
  static void showScanResult(
    BuildContext context, {
    required bool success,
    required String message,
    bool alreadyApproved = false,
    required VoidCallback onScanNext,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  width: 80.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.dialogBgStart,
                        MyColors.dialogBgEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.sp),
                    border: Border.all(
                      color: success
                          ? (alreadyApproved ? Colors.amber : Colors.greenAccent)
                          : Colors.redAccent.withValues(alpha: 0.8),
                      width: 2.sp,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (success
                                ? (alreadyApproved ? Colors.amber : Colors.greenAccent)
                                : Colors.redAccent)
                            .withValues(alpha: 0.15),
                        blurRadius: 20.sp,
                        spreadRadius: 2.sp,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 5.h), // Space for floating icon
                        text_widget(
                          success
                              ? (alreadyApproved ? "Already Approved" : "Scan Success")
                              : "Scan Failed",
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.5.h),
                        text_widget(
                          message,
                          fontSize: 15.sp,
                          color: Colors.white70,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Expanded(
                              child: onPress(
                                ontap: onDone,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.2.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 1.5.sp,
                                    ),
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  child: Center(
                                    child: text_widget(
                                      "Done",
                                      fontSize: 14.5.sp,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: onPress(
                                ontap: onScanNext,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.2.h),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        MyColors.primary,
                                        MyColors.goldButtonEnd,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(12.sp),
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 8.sp,
                                        offset: Offset(0, 3.sp),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: text_widget(
                                      "Scan Next",
                                      fontSize: 14.5.sp,
                                      color: MyColors.dialogBgEnd,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.5.h),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: MyColors.dialogBgEnd,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: success
                            ? (alreadyApproved ? Colors.amber : Colors.greenAccent)
                            : Colors.redAccent,
                        width: 2.sp,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (success
                                  ? (alreadyApproved ? Colors.amber : Colors.greenAccent)
                                  : Colors.redAccent)
                              .withValues(alpha: 0.35),
                          blurRadius: 12.sp,
                          spreadRadius: 2.sp,
                        ),
                      ],
                    ),
                    child: Icon(
                      success
                          ? (alreadyApproved ? RemixIcons.alarm_warning_fill : RemixIcons.checkbox_circle_fill)
                          : RemixIcons.close_circle_fill,
                      color: success
                          ? (alreadyApproved ? Colors.amber : Colors.greenAccent)
                          : Colors.redAccent,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
