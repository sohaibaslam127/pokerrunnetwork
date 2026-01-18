import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

class ParticipantList extends StatefulWidget {
  EventModel event;
  ParticipantList(this.event, {super.key});

  @override
  State<ParticipantList> createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
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
              widget.event.pokerName.capitalize!,
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
                    key: Key("members:${widget.event.id}"),
                    isLive: true,
                    onEmpty: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30.h),
                        child: Text(
                          "No Event Found",
                          style: GoogleFonts.abel(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    initialLoader: Padding(
                      padding: EdgeInsets.only(bottom: 45.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: MyColors.primary,
                        ),
                      ),
                    ),
                    separator: Container(height: 1.h),
                    itemBuilder: (BuildContext context, documentSnapshots, index) {
                      GamePlayerModel game = GamePlayerModel.toModel(
                        documentSnapshots[index].data() as Map<String, dynamic>,
                      );
                      if (game.roadName == "") return Container();
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
                                    '${index + 1}. ${game.roadName.capitalizeFirst}',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  Spacer(),
                                  if (game.rank != "")
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                      ),
                                      height: 3.4.h,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: text_widget(
                                          "RANK: ${game.rank.capitalize!}",
                                          fontSize: 14.4.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  text_widget(
                                    game.userName,
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(5, (index) {
                                  if (index < game.cards.length) {
                                    final cardKey = game.cards[index];
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
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    query: FirestoreServices.I.getGamePlayers(
                      widget.event.id,
                      "",
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
