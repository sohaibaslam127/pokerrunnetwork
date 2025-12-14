import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/home/completed_poker.dart';
import 'package:pokerrunnetwork/page/home/create_poker.dart';
import 'package:pokerrunnetwork/page/home/existing_pokers.dart';
import 'package:pokerrunnetwork/page/home/faq_page.dart';
import 'package:pokerrunnetwork/page/home/schedule_poker.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AffilateMenuPage extends StatefulWidget {
  const AffilateMenuPage({super.key});

  @override
  State<AffilateMenuPage> createState() => _AffilateMenuPageState();
}

class _AffilateMenuPageState extends State<AffilateMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff000435),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  onPress(
                    ontap: () {
                      Get.back();
                    },
                    child: Image.asset("assets/icons/bb.png", height: 3.h),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Image.asset("assets/icons/logo.png", height: 24.h),
                  ),
                  Spacer(),
                  Center(
                    child: text_widget(
                      "Poker Run Network\nAffiliate Management Page",
                      textAlign: TextAlign.center,
                      fontSize: 22.sp,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: onPress(
                          ontap: () {
                            Get.to(CreatePoker());
                          },
                          child: Image.asset(
                            "assets/icons/p31.png",
                            height: 18.h,

                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: onPress(
                          ontap: () {
                            Get.to(SchedulePoker(isCoManager: false));
                          },
                          child: Image.asset(
                            "assets/icons/p32.png",
                            height: 18.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: onPress(
                          ontap: () {
                            Get.to(CompletedPoker());
                          },
                          child: Image.asset(
                            "assets/icons/p33.png",
                            height: 18.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: onPress(
                          ontap: () {
                            Get.to(ExistingPokers());
                          },
                          child: Image.asset(
                            "assets/icons/p34.png",
                            height: 18.h,
                            fit: BoxFit.cover,
                          ),
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
                            "Video’s and FAQ’s",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
