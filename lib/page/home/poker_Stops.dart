import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/poker_Sponsers.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerStops extends StatefulWidget {
  const PokerStops({super.key});

  @override
  State<PokerStops> createState() => _PokerStopsState();
}

class _PokerStopsState extends State<PokerStops> {
  bool shouldCheck = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/icons/bbg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),

                  Center(
                    child: Container(
                      width: 88.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                onPress(
                                  ontap: () {
                                    Get.back();
                                  },
                                  child: Image.asset(
                                    "assets/icons/back.png",
                                    height: 3.6.h,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                text_widget(
                                  "Poker Run Stops",

                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                int number = index + 1;

                                String suffix;
                                if (number == 1)
                                  suffix = "st";
                                else if (number == 2)
                                  suffix = "nd";
                                else if (number == 3)
                                  suffix = "rd";
                                else
                                  suffix = "th";

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text_widget(
                                      "$number$suffix Stops",
                                      color: Color(0xff6C7278),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 0.5.h),

                                    // Name Field
                                    textFieldWithPrefixSuffuxIconAndHintText(
                                      "Name of $number$suffix Poker Run Stop",
                                      fillColor: Colors.white,
                                      mainTxtColor: Colors.black,
                                      radius: 12,

                                      bColor: Color(0xffEDF1F3),
                                      hintColor: Color(0xff868686),
                                      pColor: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.3.h),

                                    // Address Field
                                    textFieldWithPrefixSuffuxIconAndHintText(
                                      "Select Address of $number$suffix Poker Run Stop",
                                      fillColor: Colors.white,
                                      mainTxtColor: Colors.black,
                                      radius: 12,

                                      bColor: Color(0xffEDF1F3),
                                      hintColor: Color(0xff868686),
                                      pColor: MyColors.primary,
                                    ),

                                    SizedBox(height: 2.h),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 2.5.h),
                            customButon(
                              isIcon: false,
                              btnText: "Continue To Sponsors",
                              icon: "assets/icons/p1.png",
                              onTap: () {
                                Get.to(PokerSponsers());

                                // Get.to(() =>  );
                              },
                            ),

                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
