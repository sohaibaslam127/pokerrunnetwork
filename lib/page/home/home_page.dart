import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/co_manager_menu.dart';
import 'package:pokerrunnetwork/page/home/affilate_menu.dart';
import 'package:pokerrunnetwork/page/home/schedule_poker.dart';
import 'package:pokerrunnetwork/page/home/setting_page.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),

                Center(
                  child: text_widget(
                    "Welcome To The\nPoker Run Network.",
                    textAlign: TextAlign.center,

                    fontSize: 25.sp,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),

                Center(
                  child: Image.asset("assets/icons/logo.png", height: 26.h),
                ),
                Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: customButon(
                    isIcon: true,
                    btnText: "Poker Run Network Affiliate",
                    icon: "assets/icons/p1.png",
                    onTap: () {
                      setState(() {
                        // userType = 1;
                      });
                      Get.to(AffilateMenuPage());
                      // Get.to(() =>  );
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: customButon(
                    isIcon: true,
                    btnText: "Poker Run Co-Manager",
                    icon: "assets/icons/p2.png",
                    onTap: () {
                      setState(() {
                        // userType = 2;
                      });
                      Get.to(SchedulePoker(isCoManager: true));

                      // Get.to(() =>  );
                    },
                  ),
                ),
                Spacer(),

                Center(
                  child: onPress(
                    ontap: () {
                      Get.to(SettingPage());
                    },
                    child: Container(
                      width: 37.w,
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
                          "Setting & Profile",
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
