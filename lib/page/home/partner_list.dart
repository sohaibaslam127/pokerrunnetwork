import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
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

class PartnerList extends StatefulWidget {
  final int type;
  final EventModel eventModel;
  const PartnerList({super.key, required this.eventModel, required this.type});

  @override
  State<PartnerList> createState() => _PartnerListState();
}

class _PartnerListState extends State<PartnerList> {
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
            leadingWidth: 8.w,
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
              widget.type == 0
                  ? "Authorize ${widget.eventModel.pokerName.capitalizeFirst} Participants"
                  : "Progress of ${widget.eventModel.pokerName.capitalizeFirst} Participants",
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
                GamePlayerModel game = GamePlayerModel.toModel(
                  documentSnapshots[index].data() as Map<String, dynamic>,
                );

                final Rx<bool?> isPaid = Rx<bool?>(null);
                if (game.iamCoRider) {
                  FirestoreServices.I
                      .isRiderPayforCorider(widget.eventModel.id, game.roadName)
                      .then((paid) {
                        isPaid.value = paid;
                      });
                } else {
                  isPaid.value = true;
                }

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
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: text_widget(
                                  game.roadName.capitalize!,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2.w),
                            ],
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 4.w,
                            right: 4.w,
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text_widget(
                                game.userName.toLowerCase(),
                                fontSize: 14.7.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.60),
                              ),
                            ],
                          ),
                          trailing: Obx(
                            () => GestureDetector(
                              onTap: () async {
                                if (!(game.iamCoRider &&
                                        isPaid.value == false) &&
                                    game.rank == "") {
                                  game.approved = !game.approved;
                                  await FirestoreServices.I.updateGamePlayer(
                                    game,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: game.approved
                                      ? Colors.green
                                      : game.iamCoRider && isPaid.value == false
                                      ? Colors.grey.shade600
                                      : Colors.red.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isPaid.value == null
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1,
                                        ),
                                      )
                                    : Text(
                                        game.rank == ""
                                            ? game.currentStop > 0
                                                  ? "Current Stop: ${game.currentStop}"
                                                  : !game.approved
                                                  ? (() {
                                                      double total = 0.0;

                                                      if (!game.iamCoRider) {
                                                        total += widget
                                                            .eventModel
                                                            .joinFee;

                                                        if (game.mycoRider) {
                                                          total += widget
                                                              .eventModel
                                                              .coRiderFee;
                                                        }

                                                        if (game.changeCard) {
                                                          total += widget
                                                              .eventModel
                                                              .changeCardFee;
                                                        }

                                                        if (game.mycoRider &&
                                                            game.isExtraCardCorider) {
                                                          total += widget
                                                              .eventModel
                                                              .changeCardFee;
                                                        }
                                                      }

                                                      return total == 0
                                                          ? "Not Paid \$0.00"
                                                          : "Not Paid \$${total.toStringAsFixed(2)}";
                                                    })()
                                                  : "Paid"
                                            : "${game.rank.capitalize}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.7.sp,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        if (game.mycoRider ||
                            game.changeCard ||
                            game.iamCoRider) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                              right: 18.0,
                              bottom: 8.0,
                            ),
                            child: Obx(
                              () => isPaid.value == null
                                  ? Center(
                                      child: SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14.7.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: [
                                          if (game.changeCard &&
                                              game.iamCoRider) ...[
                                            TextSpan(text: "Co-rider with "),
                                            TextSpan(
                                              text: game
                                                  .mycoRiderName
                                                  .capitalizeFirst,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " and change card option.",
                                            ),
                                          ] else if (game.iamCoRider) ...[
                                            TextSpan(
                                              text: "I am a co-rider of ",
                                            ),
                                            TextSpan(
                                              text: game
                                                  .mycoRiderName
                                                  .capitalizeFirst,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ] else if (game.mycoRider &&
                                              game.changeCard) ...[
                                            const TextSpan(
                                              text: "Riding with Co-rider: ",
                                            ),
                                            TextSpan(
                                              text: game
                                                  .mycoRiderName
                                                  .capitalizeFirst,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: " with change card option.",
                                            ),
                                          ] else if (game.mycoRider) ...[
                                            const TextSpan(
                                              text: "Riding with Co-rider: ",
                                            ),
                                            TextSpan(
                                              text: game
                                                  .mycoRiderName
                                                  .capitalizeFirst,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const TextSpan(text: "."),
                                          ] else if (game.changeCard) ...[
                                            const TextSpan(
                                              text:
                                                  "Change card option included.",
                                            ),
                                          ],
                                          if (game.iamCoRider &&
                                              isPaid.value == false) ...[
                                            const TextSpan(
                                              text:
                                                  "\nThe primary rider has not been",
                                            ),
                                            const TextSpan(
                                              text:
                                                  " marked as paid/authorized by the organizer. ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  "Have the primary rider check in with the organizer at the starting location.",
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              query: widget.type == 0
                  ? FirestoreServices.I.getGamePlayers(widget.eventModel.id, "")
                  : FirestoreServices.I.getGamePlayersProgress(
                      widget.eventModel.id,
                      "",
                    ),
              itemBuilderType: PaginateBuilderType.listView,
            ),
          ),
        ),
      ],
    );
  }
}
