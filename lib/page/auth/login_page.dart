import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/forget_page.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
          .then((result) {
            EasyLoading.dismiss();
            if (result.isEmpty) {
              Get.offAll(const HomePage());
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Spacer(flex: 2),
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
      ],
    );
  }
}
