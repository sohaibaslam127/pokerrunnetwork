import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/random.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StopView extends StatefulWidget {
  const StopView({super.key});

  @override
  State<StopView> createState() => _StopViewState();
}

class _StopViewState extends State<StopView> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  int count = 0;

  NRandom ran = NRandom(52, 4);
  void randomCard() {
    int number = ran.getNextIndex();
    if (currentGame.game.cards.contains(number)) {
      randomCard();
    } else {
      currentGame.game.cards.add(number);
    }
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
            leadingWidth: 8.w,
            title: text_widget(
              "Card for stop ${currentGame.game.currentStop}",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
          ),
          body: Column(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(5, (index) {
                            final hasCard =
                                index < currentGame.game.cards.length;
                            return Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: hasCard
                                  ? Image.asset(
                                      pokerCards[currentGame.game.cards[index]],
                                      width: 13.5.w,
                                      height: 80,
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      width: 13.5.w,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Center(
                          child: Image.asset(
                            pokerCards[currentGame
                                .game
                                .cards[currentGame.game.currentStop - 1]],
                            width: 76.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
              Spacer(),
              onPress(
                ontap: () async {
                  count = 0;
                  currentGame.game.currentStop += 1;
                  await FirestoreServices.I.updateGamePlayer(currentGame.game);
                  Get.back();
                },
                child: Image.asset(OtherButtons.keepThisCard),
              ),
              if (currentGame.game.changeCard && count < 1) ...[
                onPress(
                  ontap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("Change Card"),
                        content: Text(
                          "Do you want to replace your card with different card?",
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text("No"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Replace Card"),
                            onPressed: () async {
                              Get.back();
                              if (count == 1) {
                                toast(
                                  context,
                                  "Card Change Limit",
                                  "Note: Only 1 permanent card change per stop",
                                );
                                return;
                              }
                              count++;
                              currentGame.game.changeCardAttempts++;
                              currentGame.game.spends =
                                  currentGame.game.spends +
                                  currentGame.latestEvent.changeCardFee;
                              randomCard();
                              currentGame.game.cards.removeAt(
                                currentGame.game.cards.length - 2,
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Image.asset(OtherButtons.changeThisCard),
                ),
                text_widget(
                  "Note: 1 permanent card change per stop",
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16.sp,
                ),
              ] else ...[
                Spacer(flex: 3),
              ],
              Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }
}
