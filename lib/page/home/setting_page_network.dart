import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> logout() async {
    showPopup(
      context,
      "Are You Sure, You Want To Logout?",
      PopupActionsButtons.cancel,
      PopupActionsButtons.logout,
      () {
        Get.back();
      },
      () async {
        Get.back();
        await AuthServices.I.logOut();
        Get.offAll(() => const LoginPage());
      },
    );
  }

  Future<void> deleteAccount() async {
    showPopup(
      context,
      "Are You Sure, You Want To Delete Your Account, You Will Not Be Able To Undo This Action?",
      PopupActionsButtons.deleteAccount,
      PopupActionsButtons.cancel,
      () async {
        Get.back();
        await FirestoreServices.I.deleteAccount();
        await AuthServices.I.logOut();
        Get.offAll(() => const LoginPage());
      },
      () {
        Get.back();
      },
    );
  }

  void editProfile() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void helpLine() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void termsAndConditions() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void reportProblem() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/icons/bbg.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 14.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 3.5),
              child: onPress(
                ontap: () {
                  Get.back();
                },
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 25.sp,
                  color: MyColors.white,
                ),
              ),
            ),
            title: text_widget(
              "Setting",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Row(
                children: [
                  // Expanded(
                  //   child: onPress(
                  //     ontap: editProfile,
                  //     child: Image.asset(MenuActionButtons.editProfile),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: onPress(
                  //     ontap: helpLine,
                  //     child: Image.asset(MenuActionButtons.helpLine),
                  //   ),
                  // ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: onPress(
                      ontap: termsAndConditions,
                      child: Image.asset(MenuActionButtons.termAndCondition),
                    ),
                  ),
                  Expanded(
                    child: onPress(
                      ontap: reportProblem,
                      child: Image.asset(MenuActionButtons.reportAProblem),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffF98080).withValues(alpha: 0.50),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        onPress(
                          ontap: logout,
                          child: Image.asset("assets/icons/out.png"),
                        ),
                        SizedBox(height: 1.6.h),
                        onPress(
                          ontap: deleteAccount,
                          child: Image.asset("assets/icons/del.png"),
                        ),
                        SizedBox(height: 1.h),
                        Image.asset("assets/icons/txt.png"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
