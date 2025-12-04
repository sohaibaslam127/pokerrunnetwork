
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AffilatePage2 extends StatefulWidget {
  const AffilatePage2({super.key});

  @override
  State<AffilatePage2> createState() => _AffilatePage2State();
}

class _AffilatePage2State extends State<AffilatePage2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       
        Scaffold(
          backgroundColor: Color(0xff000435),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  SizedBox(height: 1.h),
                  Center(
                    child: Image.asset("assets/icons/logo.png", height: 24.h),
                  ),
                   SizedBox(height: 3.h),
              
                  Center(
                    child: text_widget(
                      "Poker Run Network Affiliate Management Page",
                      textAlign: TextAlign.center,
              
                      fontSize: 22.sp,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                 Row(
                  children: [
                    Expanded(child: Image.asset("assets/icons/p31.png",height: 16.h,)),
                    // SizedBox(width: 1.w),
                    Expanded(child: Image.asset("assets/icons/p32.png",height: 16.h,)),

                  ],
                 ),
                   SizedBox(height: 2.h),
                 Row(
                  children: [
                    Expanded(child: Image.asset("assets/icons/p33.png",height: 16.h,)),
                    // SizedBox(width: 1.w),
                    Expanded(child: Image.asset("assets/icons/p34.png",height: 16.h,)),

                  ],
                 ),
                   SizedBox(height: 2.5.h),
                
                
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
