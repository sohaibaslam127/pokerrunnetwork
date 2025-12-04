import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/affilate_page.dart';
import 'package:pokerrunnetwork/page/home/affilate_page2.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset("assets/icons/logo.png", height: 19.h),
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
                      width: 92.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Enter your Email'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 2.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '*******'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xffACB5BB),

                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                            SizedBox(height: 2.5.h),
                            Row(
                              children: [
                                Spacer(),
                                text_widget(
                                  "Forgot Password?",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.primary1,
                                ),
                            SizedBox(height: 2.5.h),

                                // Spacer(),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                           customButon(
                              isIcon: false,
                              btnText: "Sign In",
                              icon: "assets/icons/p1.png",
                              onTap: (){
                                Get.to(HomePage());
                                // Get.to(() =>  );
                              },
                            ),
                            SizedBox(height: 3.h),
                                     Center(
                                       child: onPress(
                                         ontap: (){
                                          Get.to(SingupPage());
                                        },
                                         child: RichText(
                                                             text: TextSpan(
                                                               text: 'Don’t have an account? ',
                                                               style: TextStyle(fontSize: 15, color: MyColors.black, fontWeight: FontWeight.w400),
                                                               children: [
                                                                 TextSpan(
                                                                   text: 'Sign Up',
                                                                   style: TextStyle(fontSize: 15, color: MyColors.primary1,fontWeight: FontWeight.bold),
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
                                       ),
                                     ),
                                    
                           

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                                    Center(
                                      child: Container(
                                        width: 32.w,
                                        height: 4.7.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.20),
                                          border: Border.all(
                                          color: Colors.white.withOpacity(0.30),

                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: text_widget("About Us",
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
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
