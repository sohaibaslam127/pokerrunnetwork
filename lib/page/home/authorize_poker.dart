import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthorizePoker extends StatefulWidget {
  const AuthorizePoker({super.key});

  @override
  State<AuthorizePoker> createState() => _AuthorizePokerState();
}

class _AuthorizePokerState extends State<AuthorizePoker> {
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
              "Authorize Poker Run Participants",
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
                  SizedBox(height: 3.5.h),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          border: Border.all(
                            color: const Color(
                              0xffFFFFFF,
                            ).withValues(alpha: 0.30),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text_widget(
                                "Mickey",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
                              text_widget(
                                "Note: co-rider  with change card option included",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
                            ],
                          ),
                          trailing: index % 2 == 0
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
                                    "Paid",
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
                                    color: Color(0xffF78952),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: text_widget(
                                    "Not Paid \$50",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
