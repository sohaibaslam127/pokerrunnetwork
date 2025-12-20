import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snackify/enums/snack_enums.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  TextEditingController emailContoller = TextEditingController();

  void forgetPassword() {
    if (!emailContoller.text.isEmail) {
      toast(context, "Valid Email", "Please enter a valid email address");
    }
    AuthServices.I.forgetPassword(emailContoller.text).then((value) {
      if (value.isEmpty) {
        Get.back();
        toast(
          context,
          "Reset Password",
          "Password reset link sent to your email",
          type: 0,
        );
      } else {
        toast(context, "Error", value, type: 1);
      }
    });
  }

  @override
  void dispose() {
    emailContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext maincontext) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/icons/bg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset("assets/logo/logo.png", height: 19.h),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: text_widget(
                      "Welcome Back To\nThe Poker Run\nNetwork.",
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
                            Row(
                              children: [
                                text_widget(
                                  "Forget Password",
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
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
                            SizedBox(height: 1.5.h),
                            Row(
                              children: [
                                Spacer(),
                                onPress(
                                  ontap: () {
                                    Get.to(SingupPage());
                                  },
                                  child: text_widget(
                                    "Register New Account",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: MyColors.secondary,
                                  ),
                                ),
                                SizedBox(height: 2.5.h),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            customButon(
                              isIcon: false,
                              btnText: "Reset Password",
                              icon: "assets/icons/p1.png",
                              onTap: forgetPassword,
                            ),
                            Center(
                              child: onPress(
                                ontap: () {
                                  Get.back();
                                },
                                child: Text(
                                  'We will send the reset password link, on your\nRegistered Email.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: MyColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: onPress(
                                ontap: () {
                                  Get.back();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I remeber my password, ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MyColors.secondary,
                                          fontWeight: FontWeight.bold,
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
                  SizedBox(height: 6.h),
                  Center(
                    child: onPress(
                      ontap: () {
                        launchMyUrl('https://thepokerrunapp.com');
                      },
                      child: Container(
                        width: 32.w,
                        height: 4.7.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.30),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: text_widget(
                            "About Us",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
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
