import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerStops extends StatefulWidget {
  const PokerStops({super.key});

  @override
  State<PokerStops> createState() => _PokerStopsState();
}

class _PokerStopsState extends State<PokerStops> {
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
                                Image.asset("assets/icons/back.png",height: 4.5.h,),
                                SizedBox(width: 2.w),
                                text_widget("Create a new Poker Run",
                                
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                ),
                               
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Name of poker run'.tr,

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
                              "Description".tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,
                              line: 3,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Select Date'.tr,

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
                              'Select Time'.tr,

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
                              'Poker Run Cost'.tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              padd: 16,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            
                           
                           SizedBox(height: 2.h),
                           text_widget("Do you want participants to have the option of adding a co-rider?",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6C7278),
                           ),
                           Row(
                            children: [
                               CustomCheckBox(
              value: shouldCheck,
              shouldShowBorder: true,
              borderColor:Color(0xff6C7278),
              checkedFillColor:MyColors.primary1,
              borderRadius: 4,
              borderWidth: 1.5,
              checkBoxSize: 16,
              onChanged: (val) {
                //do your stuff here
                setState(() {
                  shouldCheck = val;
                });
              },
            ),
                            SizedBox(width: 1.w),
                            text_widget("Yes",
                             fontSize: 15.sp,
                             fontWeight: FontWeight.bold,
                             color: Color(0xff6C7278),
                            ),
                            SizedBox(width: 6.w),
                              CustomCheckBox(
              value: shouldCheck,
              shouldShowBorder: true,
              borderColor:Color(0xff6C7278),
              checkedFillColor:MyColors.primary1,
              borderRadius: 4,
              borderWidth: 1.5,
              checkBoxSize: 16,
              
              onChanged: (val) {
                //do your stuff here
                setState(() {
                  shouldCheck = val;
                });
              },
            ),
                            SizedBox(width: 1.w),
                            text_widget("No",
                             fontSize: 15.sp,
                             fontWeight: FontWeight.bold,
                             color: Color(0xff6C7278),
                            ),
                            ],
                           ),
                             SizedBox(height: 2.h),
                           text_widget("Do you want participants to have the option of changing their card at each stop?",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6C7278),
                           ),
                           Row(
                            children: [
                               CustomCheckBox(
              value: shouldCheck,
              shouldShowBorder: true,
              borderColor:Color(0xff6C7278),
              checkedFillColor:MyColors.primary1,
              borderRadius: 4,
              borderWidth: 1.5,
              checkBoxSize: 16,
              onChanged: (val) {
                //do your stuff here
                setState(() {
                  shouldCheck = val;
                });
              },
            ),
                            SizedBox(width: 1.w),
                            text_widget("Yes",
                             fontSize: 15.sp,
                             fontWeight: FontWeight.bold,
                             color: Color(0xff6C7278),
                            ),
                            SizedBox(width: 6.w),
                              CustomCheckBox(
              value: shouldCheck,
              shouldShowBorder: true,
              borderColor:Color(0xff6C7278),
              checkedFillColor:MyColors.primary1,
              borderRadius: 4,
              borderWidth: 1.5,
              checkBoxSize: 16,
              
              onChanged: (val) {
                //do your stuff here
                setState(() {
                  shouldCheck = val;
                });
              },
            ),
                            SizedBox(width: 1.w),
                            text_widget("No",
                             fontSize: 15.sp,
                             fontWeight: FontWeight.bold,
                             color: Color(0xff6C7278),
                            ),
                            ],
                           ),

                            SizedBox(height: 2.5.h),
                           customButon(
                              isIcon: false,
                              btnText: "Continue",
                              icon: "assets/icons/p1.png",
                              onTap: (){
                                // Get.to(() =>  );
                              },
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
