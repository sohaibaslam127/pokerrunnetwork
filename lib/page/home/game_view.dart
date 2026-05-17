import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/random.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/analysis.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/models/sponsors.dart';
import 'package:pokerrunnetwork/models/stops.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/page/home/stop_view.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_ad_widget.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  StopsModel stopsModel = StopsModel();
  int stopNumber = 0;
  String finalUrl = "";
  double distance = 0;

  NRandom ran = NRandom(52, 4);
  void randomCard() {
    int number = ran.getNextIndex();
    if (currentGame.game.cards.contains(number)) {
      randomCard();
    } else {
      currentGame.game.cards.add(number);
    }
  }

  SponsorsModel _pickSponsorFor(int stopNumber) {
    final enabled = sponsorLinks.where((s) => s.enable);
    final stopSpecific = enabled
        .where((s) => s.stop.isNotEmpty && s.stop.contains(stopNumber))
        .toList();
    if (stopSpecific.isNotEmpty) {
      stopSpecific.shuffle();
      return stopSpecific.first;
    }
    final global = enabled.where((s) => s.stop.isEmpty).toList();
    if (global.isNotEmpty) {
      global.shuffle();
      return global.first;
    }
    return SponsorsModel()..link = "https://www.tomorrowbyte.com/";
  }

  @override
  Widget build(BuildContext context) {
    stopsModel = currentGame.latestEvent.stops[currentGame.game.currentStop];
    stopNumber = currentGame.game.currentStop;
    finalUrl = normalizeUrl(stopsModel.sponserLink);
    SponsorsModel? fallbackSponsor;

    String fallbackSponsorUrl = "";
    if (finalUrl.isEmpty) {
      fallbackSponsor = _pickSponsorFor(stopNumber);
      fallbackSponsorUrl = normalizeUrl(fallbackSponsor.link);
    }

    calculateDistance(
      currentUser.location.latitude,
      currentUser.location.longitude,
      stopsModel.stopLocation.latitude,
      stopsModel.stopLocation.longitude,
    ).then((value) {
      distance = value;
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {});
      });
    });
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
            automaticallyImplyLeading: false,
            leadingWidth: 8.w,
            title: text_widget(
              currentGame.latestEvent.pokerName.capitalize!,
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(height: 2, color: Colors.white12),
            ),
            actions: [
              onPress(
                ontap: () async {
                  if (stopNumber == 6) {
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return const PokerResultDialog();
                      },
                    );
                    Get.offAll(() => const HomePage());
                  } else {
                    showPopup(
                      context,
                      "If you exit this game, you will lose all progress and must re-register to play this event?",
                      PopupActionsButtons.cancel,
                      PopupActionsButtons.exit,
                      () {
                        Get.back();
                      },
                      () async {
                        Get.back();
                        EasyLoading.show(status: "Leaving...");
                        currentGame.latestEvent.userIds.remove(currentUser.id);
                        await FirestoreServices.I.updateEvent(
                          context,
                          currentGame.latestEvent,
                          false,
                          false,
                        );
                        EasyLoading.dismiss();
                        Get.offAll(HomePage());
                      },
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: text_widget(
                    stopNumber == 6 ? "LEAVE  " : "EXIT  ",
                    color: Colors.redAccent,
                    maxline: 1,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: text_widget(
                              "Stop $stopNumber: ${stopsModel.name}",
                              color: Colors.white.withValues(alpha: 0.8),
                              maxline: 1,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: onPress(
                        ontap: () {
                          if (finalUrl.isNotEmpty) {
                            launchMyUrl(finalUrl);
                          } else if (fallbackSponsorUrl.isNotEmpty) {
                            launchMyUrl(fallbackSponsorUrl);
                          }
                        },
                        child: Row(
                          children: [
                            text_widget(
                              "Sponsored: ${(finalUrl.isNotEmpty ? stopsModel.sponserName : (fallbackSponsor?.name ?? stopsModel.sponserName)).capitalize}",
                              color: Colors.white.withValues(alpha: 0.8),
                              maxline: 1,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                            ),
                            Spacer(),
                            Icon(
                              (finalUrl.isNotEmpty ||
                                      fallbackSponsorUrl.isNotEmpty)
                                  ? RemixIcons.link
                                  : Icons.campaign_outlined,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    SizedBox(
                      height: 52.h,
                      child: finalUrl.isNotEmpty
                          ? Stack(
                              children: [
                                InAppWebView(
                                  key: Key(finalUrl),
                                  initialUrlRequest: URLRequest(
                                    url: WebUri(finalUrl),
                                  ),
                                  initialSettings: InAppWebViewSettings(
                                    javaScriptEnabled: true,
                                    mediaPlaybackRequiresUserGesture: false,
                                    useHybridComposition: true,
                                  ),
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  onLoadStop: (controller, url) {
                                    setState(() => isLoading = false);
                                  },
                                ),
                                if (isLoading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: MyColors.primary,
                                    ),
                                  ),
                              ],
                            )
                          : fallbackSponsorUrl.isNotEmpty
                          ? Stack(
                              children: [
                                InAppWebView(
                                  key: Key(fallbackSponsorUrl),
                                  initialUrlRequest: URLRequest(
                                    url: WebUri(fallbackSponsorUrl),
                                  ),
                                  initialSettings: InAppWebViewSettings(
                                    javaScriptEnabled: true,
                                    mediaPlaybackRequiresUserGesture: false,
                                    useHybridComposition: true,
                                  ),
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  onLoadStop: (controller, url) {
                                    setState(() => isLoading = false);
                                  },
                                ),
                                if (isLoading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: MyColors.primary,
                                    ),
                                  ),
                              ],
                            )
                          : CustomAdInlineWidget(
                              height: 52.h,
                              isMedium: true,
                              radius: 0,
                            ),
                    ),

                    SizedBox(height: .5.h),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      margin: EdgeInsets.all(2.w),
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.40),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: text_widget(
                                  stopsModel.address,
                                  color: Colors.white,
                                  maxline: 2,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.5.w),
                                  child: text_widget(
                                    "${distance.toStringAsFixed(2)}\nMiles",
                                    textAlign: TextAlign.center,
                                    fontSize: 14.4.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: onPress(
                        ontap: () {
                          openMaps(
                            context,
                            currentGame.latestEvent.stops[stopNumber].name,
                            currentGame
                                .latestEvent
                                .stops[stopNumber]
                                .stopLocation
                                .latitude,
                            currentGame
                                .latestEvent
                                .stops[stopNumber]
                                .stopLocation
                                .longitude,
                            currentGame.latestEvent.stops[stopNumber - 1].name,
                            currentUser.location.latitude,
                            currentUser.location.longitude,
                          );
                        },
                        child: Image.asset(
                          stopNumber == 1
                              ? OtherButtons.navigate1
                              : stopNumber == 2
                              ? OtherButtons.navigate2
                              : stopNumber == 3
                              ? OtherButtons.navigate3
                              : stopNumber == 4
                              ? OtherButtons.navigate4
                              : stopNumber == 5
                              ? OtherButtons.navigate5
                              : OtherButtons.finalDestination,
                        ),
                      ),
                    ),
                    Expanded(
                      child: onPress(
                        ontap: () async {
                          if (distance < miles) {
                            if (currentGame.game.currentStop != 6) {
                              randomCard();
                              await Get.to(StopView());
                              setState(() {});
                              if (currentGame.game.currentStop == 6) {
                                HandResult myHand = Analysis().converter(
                                  List<int>.from(currentGame.game.cards),
                                );
                                currentGame.game.rank = myHand.rank;
                                currentGame.game.rankValue = myHand.score;
                                FirestoreServices.I.updateGamePlayer(
                                  currentGame.game,
                                );
                              }
                            } else {
                              await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return const PokerResultDialog();
                                },
                              );
                              Get.offAll(() => const HomePage());
                            }
                          } else {
                            toast(
                              context,
                              "Next Location",
                              "Navigate to the Next Location, By using the Navigate Button",
                            );
                          }
                        },
                        child: Image.asset(
                          stopNumber == 1
                              ? OtherButtons.card1
                              : stopNumber == 2
                              ? OtherButtons.card2
                              : stopNumber == 3
                              ? OtherButtons.card3
                              : stopNumber == 4
                              ? OtherButtons.card4
                              : stopNumber == 5
                              ? OtherButtons.card5
                              : OtherButtons.completeYourPokerRun,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
