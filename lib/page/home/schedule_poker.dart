import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/game_view.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchedulePokerN extends StatefulWidget {
  const SchedulePokerN({super.key});

  @override
  State<SchedulePokerN> createState() => _SchedulePokerNState();
}

class _SchedulePokerNState extends State<SchedulePokerN> {
 
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
              "Test Event",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            actions: [
              Image.asset("assets/icons/down.png",height: 3.h),
              SizedBox(width: 4.w),
            ],
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 15),
                          child: Row(
                            children: [
                           
                              text_widget("Use the drop down menu to switch\nbetween Active poker runs",
                              fontSize: 16.5.sp,color:Colors.white,
                              fontWeight: FontWeight.w600,
                              ),
                              Spacer(),
                              Image.asset("assets/icons/up.png",height: 4.5.h),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                
                      text_widget("Poker Run will begin on",fontSize: 17.sp,fontWeight: FontWeight.w600,color: Colors.white),
                      SizedBox(height: 1.h),
                
                      text_widget("Date: 31 DEC 25 at 2:13\nPlease go to the starting point before the poker run begins and check in with organizers to activate this poker run",
                      fontSize: 15.5.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                      ),
                
                SizedBox(height: 3.h),
                      text_widget("Starting point",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
                      SizedBox(height: 0.5.h),
                      text_widget("F35Q+9RX, MUSLIM TOWN, BLOCK B MUSLIM TOWN, FAISALABAD, PAKISTAN",
                      fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                      ),
                
                SizedBox(height: 3.h),
                
                 Image.asset("assets/icons/nav.png"),
                
                 SizedBox(height: 3.h),
                
                 Row(
                  children: [
                    text_widget("Distance: 48.47 Miles",fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),
                  
                  ],
                 ),
                  SizedBox(height: 1.5.h),
                      text_widget('''Your poker run will begin at the date and time above. you must be within 0.062 miles of the start location to begin your poker run.\nOnce your poker run begins. go to the first poker run stop to unlock your first card.''',
                      fontSize: 15.sp,color: MyColors.white.withOpacity(0.60),height: 1.7
                      ),
                
                          ],
                  ),
                ),
                  SizedBox(height: 1.5.h),

 onPress(
  ontap: (){
    Get.to(GameView());
  },
  child: Image.asset(OtherButtons.startYourPokerRun,)),
                  SizedBox(height: 5.h),


              ],
            ),
          ),
        ),
      ],
    );
  }
}
