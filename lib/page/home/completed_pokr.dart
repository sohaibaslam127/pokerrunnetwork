import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  void deletePopup(EventModel event) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3B70),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Are You Sure You Want To Delete\nThis Poker Run?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: onPress(
                      ontap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        PopupActionsButtons.no,
                        height: 9.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: onPress(
                      ontap: () async {
                        Get.back();
                        EasyLoading.show(status: "Leaving...");
                        event.userIds.remove(currentUser.id);
                        await FirestoreServices.I.updateEvent(
                          context,
                          event,
                          false,
                          false,
                        );
                        EasyLoading.dismiss();
                      },
                      child: Image.asset(
                        PopupActionsButtons.yes,
                        height: 9.h,
                        fit: BoxFit.cover,
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
              "Completed Poker Run".capitalize!,
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
                              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                    ),
                                    child: Row(
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
                                            "d MMM yyyy",
                                          ).format(event.eventDate),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 1.h),
                                            if (event.eventWinner?.userId ==
                                                currentUser.id)
                                              Text(
                                                "Congratulation's シ\n${event.eventWinner?.roadName.capitalizeFirst}",
                                                style: GoogleFonts.bungee(
                                                  textStyle: TextStyle(
                                                    color:
                                                        Colors.green.shade300,
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
                                            if ((event.eventWinner?.rank ??
                                                    "") !=
                                                "")
                                              Row(
                                                children: [
                                                  text_widget(
                                                    "Rank: ",
                                                    fontSize: 15.5.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  text_widget(
                                                    event.eventWinner?.rank ??
                                                        "",
                                                    fontSize: 15.5.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Spacer(),
                                        Icon(
                                          Remix.arrow_right_s_line,
                                          color: Colors.white,
                                          size: 3.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 1.w,
                                      right: 1.w,
                                    ),
                                    child: SizedBox(
                                      height: 9.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(5, (index) {
                                          if (index <
                                              event.eventWinner!.cards.length) {
                                            final cardKey =
                                                event.eventWinner!.cards[index];
                                            return Expanded(
                                              child: Image.asset(
                                                pokerCards[cardKey],
                                              ),
                                            );
                                          }
                                          return Expanded(
                                            child: Image.asset(
                                              pokerCards[0],
                                              color: Colors.grey,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: onPress(
                                            ontap: () {
                                              deletePopup(event);
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
