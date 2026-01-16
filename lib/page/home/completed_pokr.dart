import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/participant_list.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompletedPokr extends StatefulWidget {
  const CompletedPokr({super.key});

  @override
  State<CompletedPokr> createState() => _FindPokerState();
}

class _FindPokerState extends State<CompletedPokr> {
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
              "Completed Poker Run",
               fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
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
                Expanded(
                  child: PaginateFirestore(
                    key: Key("completed_poker: ${currentUser.id}"),
                    isLive: true,
                    query: FirestoreServices.I.getCompletedEvents(),
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
                    initialLoader: Padding(
                      padding: EdgeInsets.only(bottom: 45.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    itemBuilder: (BuildContext context, documentSnapshots, index) {
                      if (documentSnapshots[index].exists) {
                        EventModel event = EventModel.toModel(
                          documentSnapshots[index].data()
                              as Map<String, dynamic>,
                        );
                        return onPress(
                          ontap: () {
                            Get.to(ParticipantList(event));
                          },
                          child: Container(
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
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      text_widget(
                                        DateFormat(
                                          "d MMM yyyy",
                                        ).format(event.eventDate),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Remix.arrow_right_s_line,
                                        color: Colors.white,
                                        size: 4.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  if (event.eventWinner?.userId ==
                                      currentUser.id)
                                    Text(
                                      "Congratulation's シ ${event.eventWinner?.roadName.capitalizeFirst}",
                                      style: GoogleFonts.bungee(
                                        textStyle: TextStyle(
                                          color: Colors.green.shade300,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      "Winner is A ${event.eventWinner?.roadName.capitalizeFirst}",
                                      maxLines: 2,
                                      style: GoogleFonts.bungee(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  if ((event.eventWinner?.rank ?? "") != "")
                                    Row(
                                      children: [
                                        text_widget(
                                          "Rank: ",
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        text_widget(
                                          event.eventWinner?.rank ?? "",
                                          fontSize: 15.5.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(5, (index) {
                                      if (index <
                                          event.eventWinner!.cards.length) {
                                        final cardKey =
                                            event.eventWinner!.cards[index];
                                        return Image.asset(
                                          pokerCards[cardKey],
                                          height: 88,
                                        );
                                      }
                                      return Container(
                                        height: 88,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: onPress(
                                          ontap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const DeletePop1(),
                                            );
                                          },
                                          child: Container(
                                            width: 22.w,
                                            height: 4.8.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFF7A7A),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: text_widget(
                                                "Delete",
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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
                        );
                      }
                      return Container();
                    },
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
