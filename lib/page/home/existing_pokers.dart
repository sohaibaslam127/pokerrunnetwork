import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExistingPokers extends StatefulWidget {
  const ExistingPokers({super.key});

  @override
  State<ExistingPokers> createState() => _ExistingPokersState();
}

class _ExistingPokersState extends State<ExistingPokers> {
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
            leadingWidth: 8.w,
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
              "Existing Poker Runs List",
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
                            "5 November 9:30 AM",
                            fontSize: 14.7.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.60),
                          ),
                          trailing: onPress(
                            ontap: () {
                              showDeleteAccountPopup1(context);
                            },
                            child: Image.asset(
                              "assets/icons/cop.png",
                              height: 2.3.h,
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

  void showDeleteAccountPopup1(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Close on tap outside
      builder: (_) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),

                  Text(
                    "Are You Sure You Want To Copy That Poker Run?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "assets/icons/no.png",
                            height: 5.h,
                          ),
                        ),
                      ),

                      // Delete Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // your delete logic here
                          },
                          child: Image.asset(
                            "assets/icons/copy.png",
                            height: 9.5.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
