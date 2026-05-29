import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gameData.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/page/home/participant_list.dart';
import 'package:pokerrunnetwork/page/home/poker_view.dart';
import 'package:pokerrunnetwork/page/home/schedule_poker.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:pokerrunnetwork/widgets/custom_ad_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ActivePokerRun extends StatefulWidget {
  const ActivePokerRun({super.key});

  @override
  State<ActivePokerRun> createState() => _ActivePokerRunState();
}

class _ActivePokerRunState extends State<ActivePokerRun> {
  TextEditingController searchPokerRun = TextEditingController();
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
              "My Poker Run List".capitalize!,
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  'Search by event name'.tr,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  mainTxtColor: Colors.white,
                  textInputAction: TextInputAction.search,
                  showPrefix: true,
                  controller: searchPokerRun,
                  onChange: (value) {
                    setState(() {});
                  },
                  prefixImage: "assets/icons/s1.png",
                  radius: 12,
                  textInputType: TextInputType.emailAddress,
                  bColor: Colors.white.withValues(alpha: 0.3),
                  hintColor: Color(0xff868686),
                  pColor: MyColors.primary,
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: PaginateFirestore(
                    key: searchPokerRun.text.isEmpty
                        ? Key("active_poker_run")
                        : Key("active_poker_run: ${searchPokerRun.text}"),
                    isLive: true,
                    onEmpty: Column(
                      children: [
                        SizedBox(height: 10.h),
                        text_widget("No Event Found", color: Colors.white),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomAdInlineWidget(
                            widgetKey: Key("active_poker_run_empty"),
                          ),
                        ),
                      ],
                    ),
                    separator: SizedBox(height: 1.h),
                    initialLoader: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    itemBuilder: (BuildContext context, documentSnapshots, index) {
                      if (documentSnapshots[index].exists) {
                        EventModel event = EventModel.toModel(
                          documentSnapshots[index].data()
                              as Map<String, dynamic>,
                        );
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: text_widget(
                                              event.pokerName,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          text_widget(
                                            DateFormat(
                                              'dd MMM, hh:mm a',
                                            ).format(event.eventDate),
                                            fontSize: 12.5.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                      ),
                                      child: Row(
                                        children: [
                                          text_widget(
                                            "Poker run",
                                            fontSize: 15.5.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                          Spacer(),
                                          text_widget(
                                            "\$${event.joinFee}",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (event.coRider != null && event.coRider!)
                                      SizedBox(height: 0.4.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                      ),
                                      child: Row(
                                        children: [
                                          text_widget(
                                            "Co-Rider",
                                            fontSize: 15.5.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                          Spacer(),
                                          text_widget(
                                            "\$${event.coRiderFee}",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: .5.h),
                                    FutureBuilder(
                                      future: FirestoreServices.I.getGamePlayer(
                                        event.id,
                                        currentUser.id,
                                      ),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                '${snapshot.error} occurred',
                                                style: GoogleFonts.abel(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            GamePlayerModel game =
                                                snapshot.data
                                                    as GamePlayerModel;
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 0,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        "Status: ${event.status == 0
                                                            ? 'Disable'
                                                            : event.status == 1
                                                            ? 'Scheduled'
                                                            : event.status == 2
                                                            ? 'Completed'
                                                            : event.status == 3
                                                            ? 'Cancel'
                                                            : event.status == 4
                                                            ? 'Reshedule'
                                                            : ''}",
                                                        style: GoogleFonts.abel(
                                                          color:
                                                              event.status == 0
                                                              ? Colors
                                                                    .red
                                                                    .shade200
                                                              : event.status ==
                                                                    1
                                                              ? Colors
                                                                    .green
                                                                    .shade200
                                                              : event.status ==
                                                                    2
                                                              ? Colors
                                                                    .green
                                                                    .shade200
                                                              : event.status ==
                                                                    3
                                                              ? Colors
                                                                    .red
                                                                    .shade200
                                                              : event.status ==
                                                                    4
                                                              ? Colors
                                                                    .red
                                                                    .shade200
                                                              : Colors
                                                                    .green
                                                                    .shade200,
                                                          fontSize: 14.5.sp,
                                                          letterSpacing: 2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      InkWell(
                                                        onTap: () async {
                                                          Get.to(
                                                            ParticipantList(
                                                              event,
                                                            ),
                                                          );
                                                        },
                                                        child: SizedBox(
                                                          height: 3.5.h,
                                                          child: Center(
                                                            child: Text(
                                                              ' All Players Ranking ',
                                                              style: GoogleFonts.abel(
                                                                color: Colors
                                                                    .transparent,
                                                                fontSize:
                                                                    14.5.sp,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    Colors
                                                                        .white,
                                                                decorationStyle:
                                                                    TextDecorationStyle
                                                                        .solid,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                shadows: [
                                                                  Shadow(
                                                                    color: Colors
                                                                        .white,
                                                                    offset:
                                                                        Offset(
                                                                          0,
                                                                          -3,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (game.cards.isNotEmpty) ...[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 1.w,
                                                      right: 1.w,
                                                      top: 1.h,
                                                    ),
                                                    child: SizedBox(
                                                      height: 9.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: List.generate(5, (
                                                          index,
                                                        ) {
                                                          if (index <
                                                              game
                                                                  .cards
                                                                  .length) {
                                                            final cardKey = game
                                                                .cards[index];
                                                            return Expanded(
                                                              child: Image.asset(
                                                                pokerCards[cardKey],
                                                              ),
                                                            );
                                                          }
                                                          return Expanded(
                                                            child: Image.asset(
                                                              pokerCards[0],
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                SizedBox(height: 1.5.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: onPress(
                                                          ontap: () async {
                                                            EasyLoading.show();
                                                            GameData
                                                            game = await FirestoreServices
                                                                .I
                                                                .getGamebyEventId(
                                                                  event.id,
                                                                  currentUser
                                                                      .id,
                                                                );
                                                            EasyLoading.dismiss();
                                                            if (game
                                                                    .game
                                                                    .pokerId
                                                                    .isNotEmpty &&
                                                                game
                                                                    .game
                                                                    .userId
                                                                    .isNotEmpty) {
                                                              currentGame =
                                                                  game;
                                                              await Get.to(
                                                                SchedulePokerN(),
                                                              );
                                                            } else {
                                                              toast(
                                                                context,
                                                                "Game Not Started",
                                                                "It seems you have already completed this game, wait for the results.",
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 4.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0xff5CAF5F,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Center(
                                                              child: text_widget(
                                                                "Mark as a current poker run",
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2.w),
                                                      InkWell(
                                                        onTap: () async {
                                                          await Get.to(
                                                            () => PokerDetailsView(
                                                              event,
                                                              GamePlayerModel(),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 4.h,
                                                          width: 25.w,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          child: Center(
                                                            child: text_widget(
                                                              "Leave",
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: MyColors.primary,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if ((index + 1) % 4 == 0) ...[
                              SizedBox(height: 1.h),
                              CustomAdInlineWidget(
                                widgetKey: ValueKey("active_poker_ad_$index"),
                              ),
                            ],
                          ],
                        );
                      }
                      return Container();
                    },
                    footer: SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.h, top: .5.h),
                        child: CustomAdInlineWidget(
                          widgetKey: const Key("active_poker_ad_footer"),
                        ),
                      ),
                    ),
                    query: searchPokerRun.text.isEmpty
                        ? FirestoreServices.I.getActiveJoinEvents()
                        : FirestoreServices.I.searchActiveEvents(
                            searchPokerRun.text,
                          ),
                    itemBuilderType: PaginateBuilderType.listView,
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
