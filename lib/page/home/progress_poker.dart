import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProgressPoker extends StatefulWidget {
  const ProgressPoker({super.key});

  @override
  State<ProgressPoker> createState() => _ProgressPokerState();
}

class _ProgressPokerState extends State<ProgressPoker> {
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
            foregroundColor: Colors.white.withValues(alpha: 0.08),
            surfaceTintColor: Colors.white.withValues(alpha: 0.08),
            backgroundColor: Colors.white.withValues(alpha: 0.08),

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
                  color: Colors.white.withValues(alpha: 0.80),
                ),
              ),
            ),
            title: text_widget(
              "Progress Poker Run Participants",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
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
                          color: Colors.white.withValues(alpha: 0.18),
                          border: Border.all(
                            color: const Color(
                              0xffFFFFFF,
                            ).withValues(alpha: 0.30), // ✅ border color
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
                          subtitle: text_widget(
                            "alexjhon@gmail.com",
                            fontSize: 14.7.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.60),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Spacer(),
                              index % 2 == 0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff34C759),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: text_widget(
                                        "Finished",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xffEBA738),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: text_widget(
                                        "Current Stop: 6",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                              Spacer(),

                              index % 2 == 0
                                  ? text_widget(
                                      "Poker hand: Stright",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.60,
                                      ),
                                    )
                                  : SizedBox(),
                              Spacer(),
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
