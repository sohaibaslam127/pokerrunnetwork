import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/affilate_menu.dart';
import 'package:pokerrunnetwork/page/home/faq_page.dart';
import 'package:pokerrunnetwork/page/home/pokerrun_list.dart';
import 'package:pokerrunnetwork/page/home/setting_page_network.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/ext/bbg.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // SizedBox(height: 1.h),
             
                Center(
                  child: Image.asset("assets/logo/logo.png", height: 22.h),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: text_widget(
                    "Manage The Golf\nClub Poker Run",
                    textAlign: TextAlign.center,

                    fontSize: 23.sp,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset("assets/ext/currentpokerrun.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 11.h,
                  ),
                ),
              
                GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 1.w,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                          onPress(
                            ontap: () {
                              // Get.to(CreatePoker(widget.eventModel));
                            },
                            child: Image.asset(
                              "assets/ext/findapokerrun.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          onPress(
                            ontap: () {
                              // Get.to(CreatePoker(widget.eventModel));
                            },
                            child: Image.asset(
                              "assets/ext/activepokerrun.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          onPress(
                            ontap: () {
                              // Get.to(CreatePoker(widget.eventModel));
                            },
                            child: Image.asset(
                              "assets/ext/completedpokerrun.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          onPress(
                            ontap: () {
                              // Get.to(CreatePoker(widget.eventModel));
                            },
                            child: Image.asset(
                              "assets/ext/profile.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        
                      ],
                    ),
                
           Spacer(),

                Center(
                  child: onPress(
                    ontap: () {
                      Get.to(FaqPage());
                    },
                    child: Container(
                      width: 40.w,
                      height: 4.7.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: text_widget(
                          "Video’s and FAQ’s",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.5.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
