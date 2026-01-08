import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/poker_view.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompletePokerView extends StatefulWidget {
  const CompletePokerView({super.key});

  @override
  State<CompletePokerView> createState() => _CompletePokerViewState();
}

class _CompletePokerViewState extends State<CompletePokerView> {


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
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 14.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 3.5),
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
              "mickey123",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                  SizedBox(height: 4.h),
                  onPress(
                    ontap: (){
                      Get.to(PokerView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                text_widget("mickey123",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                    Spacer(),
                                    Container(
                                        width: 30.w,
                                        height: 3.4.h,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child:  text_widget("RANK: LOVEABLE",
                                      fontSize: 14.4.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                             Row(
                               children: [
                               text_widget("Mickey",
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.6)),
                                        Spacer(),
                               ],
                             ),
                               SizedBox(height: 1.h),
                            Image.asset("assets/icons/cards.png", ),
                            SizedBox(height: 2.h),
                          text_widget("Note: co-rider  with change card option included",
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.6)),

                    
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
