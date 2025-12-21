import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/create_poker.dart';
import 'package:pokerrunnetwork/page/home/manager_pokerRun.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/*
Type of the page
1 - View Scheduled Poker Runs
2 - View Completed Poker Runs
3 - Copy an Existing Poker Run
4 - Co-Manager Poker Runs
*/

class PokerRunList extends StatefulWidget {
  final int type;
  const PokerRunList({super.key, required this.type});

  @override
  State<PokerRunList> createState() => _SchedulePokerState();
}

class _SchedulePokerState extends State<PokerRunList> {
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
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 14.w,
            leading: onPress(
              ontap: () {
                Get.back();
              },
              child: Icon(
                RemixIcons.arrow_left_s_line,
                size: 24.sp,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            title: text_widget(
              widget.type == 1
                  ? "Scheduled Poker Runs List"
                  : widget.type == 2
                  ? "Completed Poker Runs List"
                  : widget.type == 3
                  ? "Copy an Existing Poker Run"
                  : "Co-Manager Poker Runs List",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: PaginateFirestore(
              key: Key("members:${currentUser.id}:${widget.type}"),
              isLive: true,
              onEmpty: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: text_widget(
                    "No Event Found",
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              initialLoader: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: CircularProgressIndicator(color: MyColors.primary),
                ),
              ),
              itemBuilder: (_, documentSnapshots, index) {
                if (documentSnapshots.isEmpty) {
                  return Container();
                }
                EventModel eventModel = EventModel.toModel(
                  documentSnapshots[index].data() as Map<String, dynamic>,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      border: Border.all(
                        color: const Color(0xffFFFFFF).withValues(alpha: 0.30),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (widget.type == 3) {
                          showPopup(
                            context,
                            "Are you sure you want to Copy an Existing Poker Run",
                            PopupActionsButtons.cancel,
                            PopupActionsButtons.copy,
                            () {
                              Get.back();
                            },
                            () {
                              Get.back();
                              eventModel.id = "";
                              eventModel.status = 1;
                              eventModel.eventWinner = null;
                              eventModel.userIds = [];
                              Get.to(CreatePoker(eventModel));
                            },
                          );
                        }
                        if (widget.type == 1 ||
                            widget.type == 2 ||
                            widget.type == 4) {
                          Get.to(ManagerPokerRun(eventModel));
                        }
                      },
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: text_widget(
                              eventModel.pokerName.capitalize!,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          if (widget.type == 2) ...[
                            onPress(
                              child: Icon(
                                RemixIcons.arrow_right_up_line,
                                size: 18.sp,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
                            ),
                          ],
                        ],
                      ),
                      contentPadding: EdgeInsets.only(left: 4.w, right: 4.w),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text_widget(
                            DateFormat(
                              'dd MMMM, hh:mm a',
                            ).format(eventModel.eventDate),
                            fontSize: 14.7.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.60),
                          ),
                          if (widget.type == 2) ...[
                            SizedBox(height: 0.5.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (eventModel.status == 2) ...[
                                  text_widget(
                                    "Winner:",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 1.3.w),
                                  Expanded(
                                    child: text_widget(
                                      eventModel
                                              .eventWinner
                                              ?.roadName
                                              .capitalizeFirst! ??
                                          "No One Join The Game",
                                      fontSize: 14.7.sp,
                                      maxline: 1,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.60,
                                      ),
                                    ),
                                  ),
                                ] else if (eventModel.status == 3) ...[
                                  text_widget(
                                    "Cancelled: ",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 1.3.w),
                                  Expanded(
                                    child: text_widget(
                                      eventModel.cancelReason,
                                      fontSize: 14.7.sp,
                                      maxline: 3,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.60,
                                      ),
                                    ),
                                  ),
                                ],
                                if (eventModel.status == 2 &&
                                    eventModel.eventWinner?.rank != null &&
                                    eventModel.eventWinner?.rank != "") ...[
                                  Spacer(),
                                  text_widget(
                                    "Rank:",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 1.3.w),
                                  text_widget(
                                    eventModel.eventWinner?.rank.capitalize! ??
                                        "",
                                    fontSize: 14.7.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.60),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: widget.type == 1 || widget.type == 4
                          ? SizedBox(
                              width: 17.5.w,
                              child: Row(
                                children: [
                                  onPress(
                                    ontap: () {
                                      if (DateTime.now().compareTo(
                                            eventModel.eventDate,
                                          ) ==
                                          -1) {
                                        showPopup(
                                          context,
                                          "Are you sure you want to ${eventModel.status == 0 ? "Enable" : "Disable"} that Poker Run?",
                                          PopupActionsButtons.disable,
                                          PopupActionsButtons.enable,
                                          () {
                                            Get.back();
                                            eventModel.status = 0;
                                            FirestoreServices.I.setEvent(
                                              context,
                                              eventModel,
                                              null,
                                              false,
                                            );
                                          },
                                          () {
                                            Get.back();
                                            eventModel.status = 1;
                                            FirestoreServices.I.setEvent(
                                              context,
                                              eventModel,
                                              null,
                                              false,
                                            );
                                          },
                                        );
                                      } else {
                                        toast(
                                          context,
                                          "Poker Run is Expire",
                                          "Change the Starting Date & Time of the Event",
                                          type: 2,
                                        );
                                      }
                                    },
                                    child: text_widget(
                                      eventModel.status == 0
                                          ? "Disable"
                                          : "Enable",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal,
                                      color: eventModel.status == 0
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    RemixIcons.arrow_right_up_line,
                                    size: 18.sp,
                                    color: Colors.white.withValues(alpha: 0.60),
                                  ),
                                ],
                              ),
                            )
                          : widget.type == 3
                          ? onPress(
                              child: Icon(
                                Icons.copy_all_outlined,
                                size: 18.sp,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
              query: widget.type == 1
                  ? FirestoreServices.I.getScheduleEvents()
                  : widget.type == 2
                  ? FirestoreServices.I.getCompletedEvents()
                  : widget.type == 3
                  ? FirestoreServices.I.getAllEvents()
                  : FirestoreServices.I.getCoAffiliateEvents(),
              itemBuilderType: PaginateBuilderType.listView,
            ),
          ),
        ),
      ],
    );
  }
}
