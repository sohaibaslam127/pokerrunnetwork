import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/poker_Stops.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerRoute extends StatefulWidget {
  const PokerRoute({super.key});

  @override
  State<PokerRoute> createState() => _PokerRouteState();
}

class _PokerRouteState extends State<PokerRoute> {
  bool shouldCheck = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
      "assets/icons/bbg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                         
  Spacer(),
               
                Center(
                  child: Container(
                    width: 88.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                             onPress(
                                  ontap: (){
                                    Get.back();
                                  },
                                  child: Image.asset("assets/icons/back.png",height: 3.6.h,)),
                              SizedBox(width: 3.w),
                              text_widget("Poker Run Route",
                              
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              ),
                             
                            ],
                          ),
                          SizedBox(height: 2.5.h),
                          text_widget("Starting point",
                          color: Color(0xff6C7278),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          
                          ),
                          SizedBox(height: 0.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            'Name of Starting point'.tr,
            
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
                            "Address of starting point".tr,
            
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            padd: 16,
            
            
                            bColor: Color(0xffEDF1F3),
                            hintColor: Color(0xff868686),
            
                            pColor: MyColors.primary,
                          ),
                          SizedBox(height: 1.3.h),
                           text_widget("Starting point",
                          color: Color(0xff6C7278),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          
                          ),
                          SizedBox(height: 0.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            'Name of Final destination'.tr,
            
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
                            'Address of Final destination'.tr,
            
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            padd: 16,
            
                            bColor: Color(0xffEDF1F3),
                            hintColor: Color(0xff868686),
            
                            pColor: MyColors.primary,
                          ),
                         
                          SizedBox(height: 2.5.h),
                         customButon(
                            isIcon: false,
                            btnText: "Continue to Stops",
                            icon: "assets/icons/p1.png",
                            onTap: (){
                              Get.to(PokerStops());
                              // Get.to(() =>  );
                            },
                          ),
                          
                                  SizedBox(height: 2.h),
                         
            
                        ],
                      ),
                    ),
                  ),
                ),
  Spacer(),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
