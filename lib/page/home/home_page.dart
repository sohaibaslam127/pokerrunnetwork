import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/page/home/active_poker_run.dart';
import 'package:pokerrunnetwork/page/home/completed_pokr.dart';
import 'package:pokerrunnetwork/page/home/faq_page.dart';
import 'package:pokerrunnetwork/page/home/find_poker.dart';
import 'package:pokerrunnetwork/page/home/game_view.dart';
import 'package:pokerrunnetwork/page/home/schedule_poker.dart';
import 'package:pokerrunnetwork/page/home/setting_page_network.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeGameData();
  }

  Future<void> _initializeGameData() async {
    final gameData = await FirestoreServices.I.getCurrentGame();
    setState(() {
      currentGame = gameData;
      if (currentGame.game.currentStop > 0) {
        Get.off(GameView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/background/lightbackground.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Center(
                  child: Image.asset("assets/logo/logo.png", height: 22.h),
                ),
                SizedBox(height: 3.h),
                Spacer(),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome Back, ",
                          style: TextStyle(
                            fontSize: 22.sp,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: currentUser.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: " (${currentUser.roadName})",
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1.1,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                if (currentGame.latestEvent.id != "") ...[
                  onPress(
                    ontap: () {
                      Get.to(SchedulePokerN());
                    },
                    child: Image.asset(
                      OtherButtons.currentPokerRun,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ] else ...[
                  Spacer(),
                ],
                GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 0.w,
                  mainAxisSpacing: 0.w,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    onPress(
                      ontap: () {
                        Get.to(FindPoker());
                      },
                      child: Image.asset(
                        MenuActionButtons.findAPokerrun,
                        fit: BoxFit.contain,
                      ),
                    ),
                    onPress(
                      ontap: () {
                        Get.to(ActivePokerRun());
                      },
                      child: Image.asset(
                        MenuActionButtons.activePokerrun,
                        fit: BoxFit.contain,
                      ),
                    ),
                    onPress(
                      ontap: () {
                        Get.to(CompletedPokr());
                      },
                      child: Image.asset(
                        MenuActionButtons.completedPokerrun,
                        fit: BoxFit.contain,
                      ),
                    ),
                    onPress(
                      ontap: () {
                        Get.to(SettingPage());
                      },
                      child: Image.asset(
                        MenuActionButtons.settingPokerrun,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
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
                        color: Colors.white.withValues(alpha: 0.18),
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
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
