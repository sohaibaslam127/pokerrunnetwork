import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/auth/profile.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pokerrunnetwork/widgets/custom_ad_widget.dart';

import 'package:pokerrunnetwork/page/legal/rules_and_legal_page.dart';

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
    Get.to(() => const ProfilePage());
  }

  void officialContestRules() {
    Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.rules));
  }

  void termsAndConditions() {
    Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.terms));
  }

  void privacyPolicy() {
    Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.privacy));
  }

  void helpLine() {
    Get.defaultDialog(
      title: "Help Line",
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xff1e1e1e),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          children: [
            text_widget(
              "Need help or have questions regarding your Poker Run?",
              color: Colors.white70,
              fontSize: 13.5.sp,
              maxline: 3,
            ),
            SizedBox(height: 2.h),
            onPress(
              ontap: () => launchMyUrl('tel:5019189189'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    RemixIcons.phone_line,
                    color: MyColors.primary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 2.w),
                  text_widget(
                    "501-918-9189",
                    color: Colors.white,
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            onPress(
              ontap: () => launchMyUrl(
                'mailto:admin@thepokerrunapp.com?subject=Poker%20Run%20Support',
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    RemixIcons.mail_line,
                    color: MyColors.secondary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 2.w),
                  text_widget(
                    "admin@thepokerrunapp.com",
                    color: Colors.white,
                    fontSize: 13.5.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: text_widget(
          "Close",
          color: MyColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void reportProblem() {
    launchMyUrl(
      'mailto:admin@thepokerrunapp.com?subject=Problem%20Report%20-%20Poker%20Run',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background/darkbackground.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leadingWidth: 9.w,
            actions: [
              onPress(
                ontap: () => Get.to(
                  () => const RulesAndLegalPage(initialTab: LegalTab.rules),
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Row(
                    children: [
                      Icon(
                        RemixIcons.trophy_line,
                        color: MyColors.primary,
                        size: 15.sp,
                      ),
                      SizedBox(width: 1.w),
                      text_widget(
                        "Rules",
                        color: MyColors.primary,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            leading: Padding(
              padding: EdgeInsets.only(bottom: 2.5, left: 1.5.w),
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
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          body: ListView(
            children: [
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        RemixIcons.information_line,
                        color: MyColors.primary,
                        size: 15.sp,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: text_widget(
                          "Apple Inc. is not a sponsor of, and is not involved in any manner with, any contest or sweepstakes in this app.",
                          fontSize: 13.5.sp,
                          color: Colors.white70,
                          maxline: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: onPress(
                      ontap: editProfile,
                      child: Image.asset(MenuActionButtons.editProfile),
                    ),
                  ),
                  Expanded(
                    child: onPress(
                      ontap: helpLine,
                      child: Image.asset(MenuActionButtons.helpLine),
                    ),
                  ),
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
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomAdInlineWidget(widgetKey: ValueKey("setting_ad")),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }
}
