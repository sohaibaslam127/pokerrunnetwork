import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/stop_view.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
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
              "The Poker Run App",
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
                      text_widget(
                        "P-36 Mian Zulfiqar Ali Road,\nCanal Block Shadman Town, Faisalabad, 38000",
                        color: Colors.white.withOpacity(0.8),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(height: 3.h),
                      SizedBox(
                        height: 45.h,
                        child: Stack(
                          children: [
                            InAppWebView(
                              initialUrlRequest: URLRequest(
                                url: WebUri("https://thepokerrunapp.com/"),
                              ),
                              initialSettings: InAppWebViewSettings(
                                javaScriptEnabled: true,
                                mediaPlaybackRequiresUserGesture: false,
                                useHybridComposition: true,
                              ),
                              onWebViewCreated: (controller) {
                                webViewController = controller;
                              },
                              onLoadStop: (controller, url) {
                                setState(() => isLoading = false);
                              },
                            ),

                            /// 🔹 Loader
                            if (isLoading)
                              const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.40),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 23.w,
                                height: 3.4.h,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: text_widget(
                                    "0.00 Miles",
                                    fontSize: 14.4.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              text_widget(
                                "P-36 Mian Zulfiqar Ali Road,\nCanal Block Shadman Town, Faisalabad, 38000",
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: onPress(
                        ontap: () {
                          showDialog(
                            context: context,
                            // This ensures the area behind the dialog is dimmed
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return const PokerResultDialog();
                            },
                          );
                        },
                        child: Image.asset(OtherButtons.navigate1),
                      ),
                    ),
                    Expanded(
                      child: onPress(
                        ontap: () {
                          Get.to(StopView());
                        },
                        child: Image.asset(OtherButtons.card1),
                      ),
                    ),
                  ],
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
