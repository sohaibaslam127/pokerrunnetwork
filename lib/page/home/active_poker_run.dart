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
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/participant_list.dart';
import 'package:pokerrunnetwork/page/home/poker_view.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
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
            backgroundColor: Colors.transparent.withValues(alpha: .2),
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
              "Active Poker Run List",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
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
                    onEmpty: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 45.h),
                        child: text_widget(
                          "No Event Found",
                          color: Colors.white,
                        ),
                      ),
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
                        if (event.userIds
                            .map((e) => e)
                            .toList()
                            .contains(currentUser.id)) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      text_widget(
                                        event.pokerName,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      Spacer(),
                                      text_widget(
                                        DateFormat(
                                          'dd MMM, hh:mm a',
                                        ).format(event.eventDate),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
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
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  if (event.coRider != null && event.coRider!)
                                    Row(
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
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  if (event.isAdditionalCard != null &&
                                      event.isAdditionalCard!)
                                    Row(
                                      children: [
                                        text_widget(
                                          "Extra card",
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                        Spacer(),
                                        text_widget(
                                          "\$${event.changeCardFee}",
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 2.h),
                                  if (event.userIds.contains(currentUser.id))
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
                                                Row(
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
                                                        color: event.status == 0
                                                            ? Colors
                                                                  .red
                                                                  .shade200
                                                            : event.status == 1
                                                            ? Colors
                                                                  .green
                                                                  .shade200
                                                            : event.status == 2
                                                            ? Colors
                                                                  .green
                                                                  .shade200
                                                            : event.status == 3
                                                            ? Colors
                                                                  .red
                                                                  .shade200
                                                            : event.status == 4
                                                            ? Colors
                                                                  .red
                                                                  .shade200
                                                            : Colors
                                                                  .green
                                                                  .shade200,
                                                        fontSize: 16.sp,
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
                                                              fontSize: 15.sp,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              decorationColor:
                                                                  Colors.white,
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
                                                if (game.cards.isNotEmpty) ...[
                                                  SizedBox(height: 1.5.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(5, (
                                                      index,
                                                    ) {
                                                      if (index <
                                                          game.cards.length) {
                                                        final cardKey =
                                                            game.cards[index];
                                                        return Image.asset(
                                                          pokerCards[cardKey],
                                                          height: 88,
                                                        );
                                                      }
                                                      return Container(
                                                        height: 88,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ],
                                                SizedBox(height: 1.5.h),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: onPress(
                                                        ontap: () async {
                                                          currentGame =
                                                              await FirestoreServices
                                                                  .I
                                                                  .getGamebyEventId(
                                                                    event.id,
                                                                    currentUser
                                                                        .id,
                                                                  );
                                                          EasyLoading.showSuccess(
                                                            "Marked as current poker run",
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 4.h,
                                                          decoration: BoxDecoration(
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
                                                              fontSize: 14.5.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        child: Center(
                                                          child: text_widget(
                                                            "Leave",
                                                            fontSize: 14.5.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                          );
                        }
                      }
                      return Container();
                    },
                    query: searchPokerRun.text.isEmpty
                        ? FirestoreServices.I.getActiveEvents()
                        : FirestoreServices.I.searchActiveEvents(
                            searchPokerRun.text,
                          ),
                    itemBuilderType: PaginateBuilderType.listView,
                  ),
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
