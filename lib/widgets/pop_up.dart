import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonActions {
  static String yesButton = "assets/icons/yes.png";
  static String noButton = "assets/icons/no.png";
  static String cancelButton = "assets/icons/cancel.png";
  static String copyButton = "assets/icons/copy.png";
  static String completeButton = "assets/icons/completed.png";
  static String deleteEventButton = "assets/icons/deleteaccount.png";
  static String deleteAccountButton = "assets/icons/deleteaccount.png";
  static String enableButton = "assets/icons/enable.png";
  static String removeButton = "assets/icons/remove.png";
  static String disableButton = "assets/icons/disable.png";
  static String logoutButton = "assets/icons/logout.png";
}

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
    builder: (context) {
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
                    child: Text(
                      title.capitalize!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
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
