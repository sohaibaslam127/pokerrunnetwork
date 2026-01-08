import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerView extends StatefulWidget {
  const PokerView({super.key});

  @override
  State<PokerView> createState() => _PokerViewState();
}

class _PokerViewState extends State<PokerView> {
 
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              onPress(
                ontap: (){
                  showDialog(context: context, builder: (context) =>  PokerJoinDialog());
                },
                child: Image.asset(OtherButtons.joinThisPokerRun)),
              Image.asset("assets/icons/no1.png"),

            ],
          ),
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
              "“????”",
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
                SizedBox(height: 1.h),
                text_widget("Test Event",fontSize: 17.sp,fontWeight: FontWeight.w600,color: Colors.white),
                SizedBox(height: 1.h),

                text_widget("Starting date: 31 DEC 37\nStarting time: 02:03 PM\nCost of poker run: \$3.40",
                fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                ),
SizedBox(height: 3.h),
                text_widget("Description",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
                SizedBox(height: 0.5.h),

                text_widget("I love that event",
                fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                ),
SizedBox(height: 3.h),
                text_widget("Starting point: Start",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
                SizedBox(height: 0.5.h),
                text_widget("F35Q+9RX, MUSLIM TOWN, BLOCK B MUSLIM TOWN, FAISALABAD, PAKISTAN",
                fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                ),

SizedBox(height: 3.h),
 Row(
  children: [
    text_widget("Riders",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
    Spacer(),
    text_widget("\$3.40",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),

  ],
 ),
 SizedBox(height: 1.3.h),
 Divider(
  thickness: 0.2,
 ),
 SizedBox(height: 1.3.h),

 Row(
  children: [
    text_widget("Total Paid to Organizer at start",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
    Spacer(),
    text_widget("\$3.40",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),

  ],
 ),
  SizedBox(height: 1.5.h),
                text_widget("The registration fee for this event is \$0.00 per participant.\nWould you like to continue",
                fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                ),


                    ],
            ),
          ),
        ),
      ],
    );
  }
}
