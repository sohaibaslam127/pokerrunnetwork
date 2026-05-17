import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CloseApp extends StatelessWidget {
  const CloseApp(this.title, this.message, {this.onRetry, super.key});

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryDark,
      body: Center(
        child: _NoInternetDialog(
          title,
          message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _NoInternetDialog extends StatelessWidget {
  const _NoInternetDialog(this.title, this.message, {this.onRetry});

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sp),
      ),
      title: text_widget(
        title,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: MyColors.black,
        textAlign: TextAlign.center,
      ),
      content: text_widget(
        message,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: MyColors.black,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: 2.h, left: 4.w, right: 4.w),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Close App Button
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: onPress(
                  ontap: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: Container(
                    height: 5.5.h,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: text_widget(
                        "Close App",
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Retry Button
            if (onRetry != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: onPress(
                    ontap: onRetry,
                    child: Container(
                      height: 5.5.h,
                      decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: text_widget(
                          "Retry",
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
