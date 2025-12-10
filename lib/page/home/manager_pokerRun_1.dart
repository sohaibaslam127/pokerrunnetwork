
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/authorize_poker.dart';
import 'package:pokerrunnetwork/page/home/co_manager.dart';
import 'package:pokerrunnetwork/page/home/completed_poker.dart';
import 'package:pokerrunnetwork/page/home/progress_poker.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManagerPokerRun1 extends StatefulWidget {
  const ManagerPokerRun1({super.key});

  @override
  State<ManagerPokerRun1> createState() => _ManagerPokerRun1State();
}

class _ManagerPokerRun1State extends State<ManagerPokerRun1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       
        Scaffold(
          backgroundColor: Color(0xff000435),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   onPress(
                    ontap: (){
                      Get.back();
                    },
                    child: Image.asset("assets/icons/bb.png",height: 3.h,)),
                    SizedBox(height: 1.h),
                    Center(
                      child: Image.asset("assets/icons/logo.png", height: 24.h),
                    ),
                     SizedBox(height: 2.h),
                
                    Center(
                      child: text_widget(
                        "Manage The Golf\nClub Poker Run",
                        textAlign: TextAlign.center,
                
                        fontSize: 22.sp,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                   Row(
                    children: [
                      Expanded(child: Image.asset("assets/icons/g1.png",height: 16.h,)),
                      // SizedBox(width: 1.w),
                      Expanded(child: onPress(
                        ontap: (){
                          Get.to(AuthorizePoker());
                        },
                        child: Image.asset("assets/icons/g2.png",height: 16.h,))),
              
                    ],
                   ),
                     SizedBox(height: 1.h),
                   Row(
                    children: [
                      Expanded(child: onPress(
                        ontap: (){
                          Get.to(ProgressPoker());
                        },
                        child: Image.asset("assets/icons/g3.png",height: 16.h,))),
                      // SizedBox(width: 1.w),
                      Expanded(child: onPress(
                        ontap: (){
                          showDeleteAccountPopup(context);
                        },
                        child: Image.asset("assets/icons/g4.png",height: 16.h,))),
              
                    ],
                   ),
                     SizedBox(height: 1.h),
              
                   Row(
                    children: [
                      Expanded(child: onPress(
                        ontap: (){
                          showDeleteAccountPopup1(context);
                         


                        },
                        child: Image.asset("assets/icons/g5.png",height: 16.h,))),
                      // SizedBox(width: 1.w),
                      Expanded(child: onPress(
                        ontap: (){
                          Get.to(CoManagerPage());
                        },
                        child: Image.asset("assets/icons/g6.png",height: 16.h,))),
              
                    ],
                   ),
                     SizedBox(height: 2.5.h),
                  
                  
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  void showDeleteAccountPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Close on tap outside
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
           padding: EdgeInsets.symmetric(horizontal:20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                SizedBox(height: 15),

                Text(
                "Are You Sure Your Poker Run Is Completed & You Are Ready To Publish The Results?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  
                  ),
                ),

                
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset("assets/icons/comp.png",height: 10.h,)
                      ),
                    ),

                    // Delete Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // your delete logic here
                        },
                        child:  Image.asset("assets/icons/no.png",height: 5.h,)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

 void showDeleteAccountPopup1(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Close on tap outside
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
             padding: EdgeInsets.symmetric(horizontal:20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                SizedBox(height: 15),

                Text(
                  "Are You Sure You Want To Delete That Poker Run?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  
                  ),
                ),

                
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset("assets/icons/yes.png",height: 10.h,)
                      ),
                    ),

                    // Delete Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // your delete logic here
                        },
                        child:  Image.asset("assets/icons/no.png",height: 5.h,)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

}


