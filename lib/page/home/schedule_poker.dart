import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/home/active_poker_run.dart';
import 'package:pokerrunnetwork/page/home/game_view.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchedulePokerN extends StatefulWidget {
  const SchedulePokerN({super.key});

  @override
  State<SchedulePokerN> createState() => _SchedulePokerNState();
}

class _SchedulePokerNState extends State<SchedulePokerN> {
  bool click = false;
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
              currentGame.latestEvent.pokerName,
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            actions: [
              onPress(
                ontap: () {
                  Get.off(ActivePokerRun());
                },
                child: Image.asset("assets/icons/down.png", height: 3.h),
              ),
              SizedBox(width: 4.w),
            ],
            centerTitle: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            text_widget(
                              "Use the drop down menu to switch\nbetween Active poker runs",
                              fontSize: 16.5.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            Spacer(),
                            Image.asset("assets/icons/up.png", height: 4.5.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Poker Run will begin on",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    SizedBox(height: 1.h),
                    text_widget(
                      "Date: ${DateFormat('dd MMM, hh:mm a').format(currentGame.latestEvent.eventDate)}\nPlease go to the starting point before the poker run begins and check in with organizers to activate this Poker Run.",
                      fontSize: 15.5.sp,
                      color: MyColors.white.withValues(alpha: 0.6),
                      height: 1.7,
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Starting point: ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: currentGame.latestEvent.stops.first.name,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: MyColors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    text_widget(
                      currentGame.latestEvent.stops.first.address,
                      fontSize: 15.sp,
                      color: MyColors.white.withValues(alpha: 0.6),
                      height: 1.7,
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: () {
                        openMaps(
                          context,
                          currentGame.latestEvent.stops.first.name,
                          currentGame
                              .latestEvent
                              .stops
                              .first
                              .stopLocation
                              .latitude,
                          currentGame
                              .latestEvent
                              .stops
                              .first
                              .stopLocation
                              .longitude,
                        );
                      },
                      child: Image.asset("assets/icons/nav.png"),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        text_widget(
                          'Distance: ${calculateDistance(currentUser.location.latitude, currentUser.location.longitude, currentGame.latestEvent.stops[0].stopLocation.latitude, currentGame.latestEvent.stops[0].stopLocation.longitude).toStringAsFixed(2)} Miles',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    text_widget(
                      '''Your poker run will begin at the date and time above. you must be within 0.062 miles of the start location to begin your poker run.\n\nOnce your poker run begins. go to the first poker run stop to unlock your first card.''',
                      fontSize: 15.sp,
                      color: MyColors.white.withValues(alpha: 0.6),
                      height: 1.7,
                    ),
                  ],
                ),
              ),
              Spacer(),
              onPress(
                ontap: () async {
                  if (click) {
                    return;
                  }
                  click = true;
                  currentGame.game.currentStop = 0;
                  if (!currentGame.game.approved) {
                    click = false;
                    toast(
                      context,
                      "Check in",
                      "Check in with organizer at starting point of event",
                    );
                  } else if (DateTime.now().compareTo(
                        currentGame.latestEvent.eventDate,
                      ) >=
                      0) {
                    if (calculateDistance(
                          currentGame
                              .latestEvent
                              .stops[currentGame.game.currentStop]
                              .stopLocation
                              .latitude,
                          currentGame
                              .latestEvent
                              .stops[currentGame.game.currentStop]
                              .stopLocation
                              .longitude,
                          currentUser.location.latitude,
                          currentUser.location.longitude,
                        ) <=
                        miles) {
                      currentGame.game.currentStop = 1;
                      await FirestoreServices.I.updateGamePlayer(
                        currentGame.game,
                      );
                      click = false;
                      Get.off(GameView());
                    } else {
                      click = false;
                      toast(
                        context,
                        "Check In",
                        "Navigate to the starting location and check in with the organizer",
                      );
                    }
                  } else {
                    click = false;
                    toast(
                      context,
                      "Poker Run",
                      "Poker Run will start at ${DateFormat("d MMM yy, h:mm aaa").format(currentGame.latestEvent.eventDate)}",
                    );
                  }
                },
                child: Image.asset(OtherButtons.startYourPokerRun),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ],
    );
  }
}
