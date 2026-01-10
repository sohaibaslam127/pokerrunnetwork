import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StopView extends StatefulWidget {
  const StopView({super.key});

  @override
  State<StopView> createState() => _StopViewState();
}

class _StopViewState extends State<StopView> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background/darkbackground.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,

            elevation: 0,
            leadingWidth: 8.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 3.5),
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
              "Card For Stop 1",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),

            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Image.asset("assets/icons/cc.png"),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
                Image.asset(OtherButtons.keepThisCard),
                Image.asset(OtherButtons.changeThisCard),
                text_widget(
                  "Note: 1 permanent card change per stop",
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16.sp,
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
