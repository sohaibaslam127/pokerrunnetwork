import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/forget_page.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pokerrunnetwork/page/legal/rules_and_legal_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();

  void signIn() {
    if (!emailContoller.text.isEmail) {
      toast(context, "Email Address", "Please enter a valid email address");
    } else if (passwordContoller.text.isEmpty) {
      toast(context, "Password", "Password is required");
    } else {
      EasyLoading.show();
      AuthServices.I
          .emailSignIn(emailContoller.text, passwordContoller.text)
          .then((result) async {
            EasyLoading.dismiss();
            if (result.isEmpty) {
              await AuthServices.I.checkUser();
              if (currentUser.id != "") {
                Get.offAll(const HomePage());
              }
            } else {
              toast(context, "Login Error", result.toString(), type: 1);
            }
          });
    }
  }

  @override
  void dispose() {
    emailContoller.dispose();
    passwordContoller.dispose();
    super.dispose();
  }

  void showAboutUsDialog() {
    Get.defaultDialog(
      title: "About The Poker Run App",
      titleStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      backgroundColor: const Color(0xff1e1e1e),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/icons/logo.png", height: 6.h),
          SizedBox(height: 1.5.h),
          text_widget(
            "The Poker Run App makes the organization & execution of a Poker Run fast and easy for participants and organizers alike.",
            color: Colors.white70,
            fontSize: 13.5.sp,
            textAlign: TextAlign.center,
            maxline: 4,
          ),
          SizedBox(height: 1.5.h),
          Container(
            padding: EdgeInsets.all(1.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: text_widget(
              "Apple Inc. is not a sponsor of, and is not involved in any manner with, any contest or games in this app.",
              color: Colors.white60,
              fontSize: 11.5.sp,
              textAlign: TextAlign.center,
              maxline: 3,
            ),
          ),
          SizedBox(height: 1.5.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 2.w,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.rules));
                },
                child: text_widget(
                  "Official Rules",
                  color: MyColors.primary,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.terms));
                },
                child: text_widget(
                  "Terms",
                  color: MyColors.secondary,
                  fontSize: 13.5.sp,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const RulesAndLegalPage(initialTab: LegalTab.privacy));
                },
                child: text_widget(
                  "Privacy",
                  color: MyColors.secondary,
                  fontSize: 13.5.sp,
                ),
              ),
            ],
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/background/lightbackground.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Center(
                    child: Image.asset("assets/logo/logo.png", height: 19.h),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: text_widget(
                      "Welcome Back To\nThe Poker Run\nPlayer.",
                      textAlign: TextAlign.center,
                      fontSize: 24.sp,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Container(
                      width: 88.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Enter your Email'.tr,
                              fillColor: Colors.white,
                              controller: emailContoller,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              textInputType: TextInputType.emailAddress,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 2.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '*******'.tr,
                              fillColor: Colors.white,
                              textInputAction: TextInputAction.done,
                              controller: passwordContoller,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              textInputType: TextInputType.visiblePassword,
                              obsecure: true,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xffACB5BB),
                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                            SizedBox(height: 1.5.h),
                            Row(
                              children: [
                                Spacer(),
                                onPress(
                                  ontap: () {
                                    Get.to(ForgetPage());
                                  },
                                  child: text_widget(
                                    "Forgot Password?",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.secondary,
                                  ),
                                ),
                                SizedBox(height: 2.5.h),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            customButon(
                              isIcon: false,
                              btnText: "Sign In",
                              onTap: signIn,
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: onPress(
                                ontap: () {
                                  Get.to(SingupPage());
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Don’t have an account? ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MyColors.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: onPress(
                      ontap: showAboutUsDialog,
                      child: Container(
                        width: 32.w,
                        height: 4.7.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.30),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: text_widget(
                            "About Us",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
