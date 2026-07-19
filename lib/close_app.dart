import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/splash_screen.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CloseApp extends StatelessWidget {
  const CloseApp(this.title, this.message, {super.key, this.onRetry, this.onSettings});

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.secondaryDark,
      body: Center(child: _NoInternetDialog(title, message, onRetry: onRetry, onSettings: onSettings)),
    );
  }
}

class _NoInternetDialog extends StatelessWidget {
  const _NoInternetDialog(this.title, this.message, {this.onRetry, this.onSettings});

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: text_widget(title, fontSize: 20.sp, fontWeight: FontWeight.bold),
      content: text_widget(message, fontSize: 16.sp),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: onSettings != null ? MyColors.secondary : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            if (onSettings != null) {
              onSettings!();
            } else {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else if (Platform.isIOS) {
                exit(0);
              }
            }
          },
          child: text_widget(
            onSettings != null ? "Settings" : "Close App",
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            EasyLoading.show(status: 'Checking connection...');
            try {
              if (onRetry != null) {
                onRetry!();
              } else {
                final bool isConnected =
                    await InternetConnectionChecker.instance.hasConnection;
                if (isConnected) {
                  Get.offAll(() => const SplashScreen());
                } else {
                  Get.snackbar(
                    "No Connection",
                    "Still no internet connection. Please try again.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              }
            } finally {
              EasyLoading.dismiss();
            }
          },
          child: text_widget(
            "Retry",
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
