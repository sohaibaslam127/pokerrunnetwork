import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/analysis.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AllHandsPage extends StatefulWidget {
  const AllHandsPage({super.key});

  @override
  State<AllHandsPage> createState() => _AllHandsPageState();
}

class _AllHandsPageState extends State<AllHandsPage> {
  Widget _buildMyHandCard(GamePlayerModel myGame) {
    String rankName = "";
    bool isComplete = myGame.cards.length >= 5;
    if (isComplete) {
      final analysisResult = Analysis().converter(List<int>.from(myGame.cards));
      rankName = analysisResult.rank.capitalize!;
    } else {
      rankName = "Drawn: ${myGame.cards.length} / 5 cards";
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    RemixIcons.user_3_line,
                    color: MyColors.primary,
                    size: 17.sp,
                  ),
                  SizedBox(width: 2.w),
                  text_widget(
                    "My Hand",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: isComplete
                      ? Colors.green.withValues(alpha: 0.2)
                      : MyColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isComplete
                        ? Colors.green.withValues(alpha: 0.5)
                        : MyColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: text_widget(
                  rankName,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? Colors.greenAccent : MyColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 9.5.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                if (index < myGame.cards.length) {
                  final cardKey = myGame.cards[index];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          pokerCards[cardKey],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: text_widget(
                          "${index + 1}",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantHandCard(GamePlayerModel otherPlayer, int index) {
    bool isComplete = otherPlayer.cards.length >= 5;
    String rankName = "";
    if (isComplete) {
      final analysisResult = Analysis().converter(
        List<int>.from(otherPlayer.cards),
      );
      rankName = analysisResult.rank.capitalize!;
    } else {
      rankName = "Stop: ${otherPlayer.currentStop}";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text_widget(
                      otherPlayer.roadName.isNotEmpty
                          ? otherPlayer.roadName.capitalizeFirst!
                          : otherPlayer.userName,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 0.3.h),
                    text_widget(
                      otherPlayer.userName,
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.5.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isComplete
                        ? Colors.green.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: text_widget(
                  rankName,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? Colors.greenAccent : Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            height: 9.5.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (cardIdx) {
                if (cardIdx < otherPlayer.cards.length) {
                  final cardKey = otherPlayer.cards[cardIdx];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.8.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          pokerCards[cardKey],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: text_widget(
                          "${cardIdx + 1}",
                          fontSize: 13.sp,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
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
              "Poker Run Hands",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          body: StreamBuilder<GamePlayerModel>(
            stream: FirestoreServices.I.gamePlayerStream(
              currentGame.latestEvent.id,
              currentUser.id,
            ),
            builder: (context, snapshot) {
              final myGame = snapshot.data ?? currentGame.game;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: _buildMyHandCard(myGame),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    child: text_widget(
                      "All Player Hands",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primary,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: PaginateFirestore(
                        key: Key(
                          "all_hands_list:${currentGame.latestEvent.id}",
                        ),
                        isLive: true,
                        onEmpty: Column(
                          children: [
                            SizedBox(height: 5.h),
                            Center(
                              child: text_widget(
                                "No other players found",
                                color: Colors.white70,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                        initialLoader: Column(
                          children: List.generate(3, (idx) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.5.h),
                              child: Shimmer(
                                duration: const Duration(seconds: 2),
                                color: Colors.white,
                                colorOpacity: 0.08,
                                child: Container(
                                  height: 15.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        separator: Container(height: 1.5.h),
                        itemBuilder:
                            (BuildContext context, documentSnapshots, index) {
                              GamePlayerModel otherPlayer =
                                  GamePlayerModel.toModel(
                                    documentSnapshots[index].data()
                                        as Map<String, dynamic>,
                                  );
                              if (otherPlayer.roadName == "")
                                return Container();
                              return _buildParticipantHandCard(
                                otherPlayer,
                                index,
                              );
                            },
                        query: FirestoreServices.I.getGamePlayers(
                          currentGame.latestEvent.id,
                          "",
                        ),
                        itemBuilderType: PaginateBuilderType.listView,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
