import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompletedPoker extends StatefulWidget {
  const CompletedPoker({super.key});

  @override
  State<CompletedPoker> createState() => _CompletedPokerState();
}

class _CompletedPokerState extends State<CompletedPoker> {
  bool faq = false;
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/icons/bbg.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.white.withOpacity(0.08),
            surfaceTintColor: Colors.white.withOpacity(0.08),
            backgroundColor: Colors.white.withOpacity(0.08),

            elevation: 0,
            leadingWidth: 14.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: onPress(
                ontap: () {
                  Get.back();
                },
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 24.sp,
                  color: Colors.white.withOpacity(0.80),
                ),
              ),
            ),
            title: text_widget(
              "Completed Poker Runs List",
              fontSize: 16.6.sp,
              color: Colors.white.withOpacity(0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          border: Border.all(
                            color: const Color(
                              0xffFFFFFF,
                            ).withOpacity(0.30), // ✅ border color
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: text_widget(
                            "Jhonson",
                            fontSize: 16.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text_widget(
                                "5 November 9:30 AM",
                                fontSize: 14.7.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.60),
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  text_widget(
                                    "Winner:",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 1.3.w),
                                  text_widget(
                                    "5 November 9:30 AM",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.60),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 2.h,
                                color: Colors.white.withOpacity(0.80),
                              ),
                              Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  text_widget(
                                    "Rank:",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 1.3.w),
                                  text_widget(
                                    "Stright",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.60),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
