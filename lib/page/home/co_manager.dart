import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoManagerPage extends StatefulWidget {
  const CoManagerPage({super.key});

  @override
  State<CoManagerPage> createState() => _CoManagerPageState();
}

class _CoManagerPageState extends State<CoManagerPage> {
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
              "Co-manager List",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            actions: [
              onPress(
                ontap: () {
                  showDeleteAccountPopup(context);
                },
                child: Image.asset("assets/icons/addc.png", height: 4.5.h),
              ),
            ],
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
                              Image.asset(
                                "assets/icons/remove.png",
                                height: 2.7.h,
                              ),
                              Spacer(),

                              text_widget(
                                "5 November",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
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

  void showDeleteAccountPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Close on tap outside
      builder: (context) {
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
                      Text(
                        "Add New Co-Manager",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter email or username".tr,
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    radius: 12,

                    bColor: Color(0xffEDF1F3),
                    hintColor: Color(0xff868686),
                    pColor: MyColors.primary,
                  ),
                  SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "assets/icons/addc1.png",
                            height: 10.h,
                          ),
                        ),
                      ),

                      // Delete Button
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
