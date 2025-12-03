import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  Center(
                    child: text_widget(
                      "Welcome To The\nPoker Run Network.",
                      textAlign: TextAlign.center,

                      fontSize: 24.sp,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Image.asset("assets/icons/logo.png", height: 32.h),
                  ),
                  SizedBox(height: 3.h),
                   SizedBox(height: 2.5.h),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal:8.0),
                             child: customButon(
                                isIcon: true,
                                btnText: "Poker Run Network Affiliate",
                                icon: "assets/icons/p1.png",
                                onTap: (){
                                  // Get.to(() =>  );
                                },
                              ),
                           ),
                            SizedBox(height: 1.h),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal:8.0),
                             child: customButon(
                                isIcon: true,
                                btnText: "Poker Run Co-Manager",
                                icon: "assets/icons/p2.png",
                                onTap: (){
                                  // Get.to(() =>  );
                                },
                              ),
                           ),
                           SizedBox(height: 6.h),
                                    Center(
                                      child: Container(
                                        width: 37.w,
                                        height: 4.7.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.20),
                                          border: Border.all(
                                          color: Colors.white.withOpacity(0.30),

                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: text_widget("Setting & Profile",
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
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
