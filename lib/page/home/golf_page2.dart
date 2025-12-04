
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GolfPage2 extends StatefulWidget {
  const GolfPage2({super.key});

  @override
  State<GolfPage2> createState() => _GolfPage2State();
}

class _GolfPage2State extends State<GolfPage2> {
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
                   
                    SizedBox(height: 1.h),
                    Center(
                      child: Image.asset("assets/icons/logo.png", height: 24.h),
                    ),
                     SizedBox(height: 3.h),
                
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
                    SizedBox(height: 3.h),
                   Row(
                    children: [
                      Expanded(child: Image.asset("assets/icons/gg1.png",height: 16.h,)),
                      // SizedBox(width: 1.w),
                      Expanded(child: Image.asset("assets/icons/gg2.png",height: 16.h,)),
              
                    ],
                   ),
                     SizedBox(height: 1.h),
                   Row(
                    children: [
                      Expanded(child: Image.asset("assets/icons/gg3.png",height: 16.h,)),
                      // SizedBox(width: 1.w),
                      Expanded(child: Image.asset("assets/icons/gg4.png",height: 16.h,)),
              
                    ],
                   ),
                     SizedBox(height: 1.h),
              
                  
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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                SizedBox(height: 15),

                Text(
                  "Are you sure your poker run is completed & you are ready to publish the results?",
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

}


