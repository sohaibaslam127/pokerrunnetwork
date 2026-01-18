import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/create_poker.dart';
import 'package:pokerrunnetwork/page/home/faq_page.dart';
import 'package:pokerrunnetwork/page/home/pokerrun_list.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leadingWidth: 9.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 2.5, left: 1.5.w),
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
              "Back",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          backgroundColor: Color(0xff000435),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2),
                  Center(
                    child: Image.asset("assets/logo/logo.png", height: 22.h),
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
                  Spacer(flex: 2),
                  SizedBox(
                    height: 40.h,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: onPress(
                                ontap: () {
                                  Get.to(CreatePoker(EventModel()));
                                },
                                child: Image.asset(
                                  MenuActionButtons.createPokerrun,
                                  height: 20.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: onPress(
                                ontap: () {
                                  Get.to(PokerRunList(type: 1));
                                },
                                child: Image.asset(
                                  MenuActionButtons.schedulePokerrun,
                                  height: 20.h,
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
                                  Get.to(PokerRunList(type: 2));
                                },
                                child: Image.asset(
                                  MenuActionButtons.completedPokerrun,
                                  height: 20.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: onPress(
                                ontap: () {
                                  Get.to(PokerRunList(type: 3));
                                },
                                child: Image.asset(
                                  MenuActionButtons.copyExistingPokerrun,
                                  height: 20.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
