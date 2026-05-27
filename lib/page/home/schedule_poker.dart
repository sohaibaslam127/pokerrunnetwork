import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/gameData.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/page/home/active_poker_run.dart';
import 'package:pokerrunnetwork/page/home/game_view.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_ad_widget.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchedulePokerN extends StatefulWidget {
  const SchedulePokerN({super.key});

  @override
  State<SchedulePokerN> createState() => _SchedulePokerNState();
}

class _SchedulePokerNState extends State<SchedulePokerN> {
  double distance = 0;
  bool click = false;
  StreamSubscription<GamePlayerModel>? _gameSub;
  @override
  void initState() {
    super.initState();
    if (currentGame.game.pokerId.isNotEmpty &&
        currentGame.game.userId.isNotEmpty) {
      calculateDistance(
        currentUser.location.latitude,
        currentUser.location.longitude,
        currentGame.latestEvent.stops[0].stopLocation.latitude,
        currentGame.latestEvent.stops[0].stopLocation.longitude,
      ).then((value) {
        distance = value;
        _gameSub = FirestoreServices.I
            .gamePlayerStream(currentGame.game.pokerId, currentGame.game.userId)
            .listen((updated) {
              if (updated.pokerId.isEmpty) return;
              currentGame.game = updated;
              if (mounted) setState(() {});
            });
      });
    } else {
      Get.back();
    }
  }

  @override
  void dispose() {
    _gameSub?.cancel();
    super.dispose();
  }

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
              currentGame.latestEvent.pokerName.capitalize!,
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  children: [
                    SizedBox(height: 1.5.h),

                    // ── Dropdown hint banner ──────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: MyColors.primary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            RemixIcons.information_line,
                            color: MyColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: text_widget(
                              "Use the drop-down menu to switch between Active Poker Runs",
                              fontSize: 14.sp,
                              color: MyColors.primary,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Image.asset(
                            "assets/icons/up.png",
                            height: 3.5.h,
                            color: MyColors.primary,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // ── Event date card ───────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.2.w),
                            decoration: BoxDecoration(
                              color: MyColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              RemixIcons.calendar_event_line,
                              color: MyColors.primary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text_widget(
                                  "Event Starts",
                                  fontSize: 12.sp,
                                  color: MyColors.white.withValues(alpha: 0.50),
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 0.4.h),
                                text_widget(
                                  DateFormat(
                                    'EEE, dd MMM yyyy  •  hh:mm a',
                                  ).format(currentGame.latestEvent.eventDate),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 0.6.h),
                                text_widget(
                                  "Check in with organizers at the starting point to activate your run.",
                                  fontSize: 13.sp,
                                  color: MyColors.white.withValues(alpha: 0.55),
                                  height: 1.4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // ── Starting point card ───────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text_widget(
                            "Starting Point",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: MyColors.white.withValues(alpha: 0.50),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                RemixIcons.map_pin_fill,
                                color: const Color(0xFFEF6C4A),
                                size: 20.sp,
                              ),
                              SizedBox(width: 2.5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text_widget(
                                      currentGame.latestEvent.stops.first.name,
                                      fontSize: 15.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 0.3.h),
                                    text_widget(
                                      currentGame
                                          .latestEvent
                                          .stops
                                          .first
                                          .address,
                                      fontSize: 13.sp,
                                      color: MyColors.white.withValues(
                                        alpha: 0.60,
                                      ),
                                      height: 1.4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            height: 0,
                          ),
                          SizedBox(height: 1.2.h),
                          Row(
                            children: [
                              // Distance badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.secondary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: MyColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      RemixIcons.route_line,
                                      color: MyColors.secondary,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    text_widget(
                                      "${distance.toStringAsFixed(2)} mi away",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.secondary,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Navigate button
                              onPress(
                                ontap: () {
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
                                    "My Location",
                                    currentUser.location.latitude,
                                    currentUser.location.longitude,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 0.9.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      text_widget(
                                        "To Starting Point",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 1.w),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: Transform.rotate(
                                          angle: 1.5,
                                          child: Icon(
                                            RemixIcons.navigation_fill,
                                            color: Colors.black,
                                            size: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // ── Instructions card ─────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                RemixIcons.flag_2_line,
                                color: MyColors.white.withValues(alpha: 0.70),
                                size: 16.sp,
                              ),
                              SizedBox(width: 2.w),
                              text_widget(
                                "How to Begin",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: MyColors.white.withValues(alpha: 0.75),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          text_widget(
                            "You must be within $miles miles of the start location to begin your Poker Run.\n\nOnce started, navigate to each stop on the route to unlock your cards.",
                            fontSize: 14.sp,
                            color: MyColors.white.withValues(alpha: 0.55),
                            height: 1.6,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    const CustomAdInlineWidget(),
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
              onPress(
                ontap: () async {
                  // if (click) return;
                  // click = true;
                  // currentGame.game.currentStop = 0;
                  // if (currentGame.game.approved) {
                  //   click = false;
                  //   toast(
                  //     context,
                  //     "Check in",
                  //     "Check in with organizer at starting point of event",
                  //   );
                  // } else if (DateTime.now().compareTo(
                  //       currentGame.latestEvent.eventDate,
                  //     ) >=
                  //     0) {
                  //   if (await calculateDistance(
                  //         currentGame
                  //             .latestEvent
                  //             .stops[currentGame.game.currentStop]
                  //             .stopLocation
                  //             .latitude,
                  //         currentGame
                  //             .latestEvent
                  //             .stops[currentGame.game.currentStop]
                  //             .stopLocation
                  //             .longitude,
                  //         currentUser.location.latitude,
                  //         currentUser.location.longitude,
                  //       ) <=
                  //       miles) {
                  currentGame.game.currentStop = 1;
                  await FirestoreServices.I.updateGamePlayer(currentGame.game);
                  click = false;
                  Get.off(GameView());
                  //     } else {
                  //       click = false;
                  //       toast(
                  //         context,
                  //         "Check In",
                  //         "Navigate to the starting location and check in with the organizer",
                  //       );
                  //     }
                  //   } else {
                  //     click = false;
                  //     toast(
                  //       context,
                  //       "Poker Run",
                  //       "Poker Run will start at ${DateFormat("d MMM yy, h:mm aaa").format(currentGame.latestEvent.eventDate)}",
                  //     );
                  //   }
                },
                child: Image.asset(OtherButtons.startYourPokerRun),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ],
    );
  }
}
