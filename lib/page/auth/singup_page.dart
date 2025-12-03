import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  bool shouldCheck = false;
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
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset("assets/icons/logo.png", height: 10.h),
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
                            Row(
                              children: [
                                text_widget("Register",
                                
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                ),
                                Spacer(),
                                Image.asset("assets/icons/dp.png",height: 6.h,),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Username'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Enter Full Name'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Enter Phone Number'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Email Address'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Password".tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xffACB5BB),

                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                             SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Confirm Password".tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xffACB5BB),

                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                           SizedBox(height: 2.h),
Row(
  children: [
    Spacer(),
     CustomCheckBox(
              value: shouldCheck,
              shouldShowBorder: true,
              borderColor:MyColors.primary1,
              checkedFillColor:MyColors.primary1,
              borderRadius: 4,
              borderWidth: 1.5,
              checkBoxSize: 18,
              onChanged: (val) {
                //do your stuff here
                setState(() {
                  shouldCheck = val;
                });
              },
            ),
            SizedBox(width: .5.w,),
            RichText(
                                                             text: TextSpan(
                                                               text: 'I Accept ',
                                                               style: TextStyle(fontSize: 15, color: MyColors.black, fontWeight: FontWeight.w400),
                                                               children: [
                                                                 TextSpan(
                                                                   text: 'Terms & Conditions',
                                                                   
                                                                   style: TextStyle(fontSize: 15, color: MyColors.primary1,fontWeight: FontWeight.bold,
                                                                   decoration: TextDecoration.underline,
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
    Spacer(),


  ],
),
                            SizedBox(height: 2.5.h),
                           customButon(
                              isIcon: false,
                              btnText: "Sign Up",
                              icon: "assets/icons/p1.png",
                              onTap: (){
                                // Get.to(() =>  );
                              },
                            ),
                            SizedBox(height: 3.h),
                                     Center(
                                       child: onPress(
                                         ontap: (){
                                          // Get.to(SignupPage());
                                        },
                                         child: RichText(
                                                             text: TextSpan(
                                                               text: 'Already have an account? ',
                                                               style: TextStyle(fontSize: 15, color: MyColors.black, fontWeight: FontWeight.w400),
                                                               children: [
                                                                 TextSpan(
                                                                   text: 'Sign In',
                                                                   style: TextStyle(fontSize: 15, color: MyColors.primary1,fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
