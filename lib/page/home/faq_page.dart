import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool faq = false;
  List<bool> faqs = [false, false, false, false, false];
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
            foregroundColor: Colors.transparent.withValues(alpha: 0.08),
            surfaceTintColor: Colors.transparent.withValues(alpha: 0.08),
            backgroundColor: Colors.transparent.withValues(alpha: 0.08),
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
              "FAQ’s & Videos",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Center(
                  child: onPress(
                    ontap: () {
                      setState(() {
                        faq = !faq;
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        faq ? "assets/icons/faq1.png" : "assets/icons/faq0.png",
                        key: ValueKey(faq), // Must add to animate swap
                        height: 8.5.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                faq == true
                    ? Column(
                        children: [
                          ...List.generate(4, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 22,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/video.png",
                                    height: 10.h,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text_widget(
                                          "Prepare for your first skateboard jump",
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          maxline: 2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        SizedBox(height: 0.2.h),
                                        text_widget(
                                          "Lorem Ipsrum is simply dummy text of the printing and typesetting industry.",
                                          color: Colors.white.withValues(
                                            alpha: 0.70,
                                          ),
                                          maxline: 3,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      )
                    : Column(
                        children: [
                          ...List.generate(
                            faqs.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 22,
                              ),
                              child: Theme(
                                data: ThemeData().copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    border: Border.all(
                                      color: const Color(0xffFFFFFF).withValues(
                                        alpha: 0.30,
                                      ), // ✅ border color
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: faqs[index],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    collapsedBackgroundColor:
                                        Colors.transparent,
                                    tilePadding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 12,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        faqs[index] = value;
                                      });
                                    },
                                    title: text_widget(
                                      " ${index + 1}.  How to create a account?",
                                      color: Colors.white,
                                      fontSize: 15.5.sp,
                                    ),
                                    iconColor: MyColors.primary,
                                    trailing: faqs[index] == true
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Icon(
                                              Remix.close_fill,
                                              color: Color(0xff7E82B4),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Icon(
                                              Remix.add_line,
                                              color: Color(0xff7E82B4),
                                            ),
                                          ),
                                    children: [
                                      text_widget(
                                        "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.",
                                        color: Colors.white.withValues(
                                          alpha: 0.70,
                                        ),
                                        fontSize: 15.sp,
                                      ),
                                      SizedBox(height: 1.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
