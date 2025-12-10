import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool faq=false;
    List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return  Stack(
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
        foregroundColor: Colors.white.withOpacity(0.08),
          surfaceTintColor:Colors.white.withOpacity(0.08),
          backgroundColor:Colors.white.withOpacity(0.08),

          elevation: 0,
          leadingWidth: 14.w,
            leading: Padding(
            padding:  EdgeInsets.only(left:17.0),
            child: onPress(
              ontap: (){
                Get.back();
              },
              child: Icon(RemixIcons.arrow_left_s_line,size: 22.sp,color:Colors.white.withOpacity(0.80),),),
          ),
          title: text_widget("Setting",
              fontSize: 17.sp,
              color: Colors.white.withOpacity(0.80),
          fontWeight: FontWeight.w600,
          ),
          centerTitle: false,
       
          
        ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
Row(
  children: [
       Expanded(child: Image.asset("assets/icons/s1.png",height: 16.h,)),
                    // SizedBox(width: 1.w),
                    Expanded(child: Image.asset("assets/icons/s2.png",height: 16.h,)),

  ],
),
 SizedBox(height: 2.h),
Row(
  children: [
       Expanded(child: Image.asset("assets/icons/s3.png",height: 16.h,)),
                    // SizedBox(width: 1.w),
                    Expanded(child: Image.asset("assets/icons/s4.png",height: 16.h,)),

  ],
),
SizedBox(height: 3.h),
Padding(
  padding: const EdgeInsets.symmetric(horizontal:20.0),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Color(0xffF98080).withOpacity(0.50),
        
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/icons/out.png"),
          SizedBox(height: 1.6.h),
          Image.asset("assets/icons/del.png"),
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
        ),
      ],
    );
  }
}