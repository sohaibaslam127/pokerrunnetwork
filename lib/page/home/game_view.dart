import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/random.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/analysis.dart';
import 'package:pokerrunnetwork/models/sponsors.dart';
import 'package:pokerrunnetwork/models/stops.dart';
import 'package:pokerrunnetwork/page/home/all_hands_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/page/home/route_map_view.dart';
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

  // ── First-stop detection state ───────────────────────────────────────────
  final Map<int, double> _allDistances = {1: 99, 2: 99, 3: 99, 4: 99, 5: 99};
  bool _calculatingAllDistances = false;
  int? _nearestInRadius;
  bool _picking = false;
  Timer? _proximityTimer;
  StreamSubscription? _eventSub;
  String _subscribedEventId = '';
  bool _gameCompletionHandled = false;

  NRandom ran = NRandom(52, 4);

  @override
  void initState() {
    super.initState();
    if (_isFirstStopPhase) {
      _refreshAllDistances();
      // Poll every 4s so the card updates as the user walks between stops
      _proximityTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (mounted && _isFirstStopPhase) {
          _refreshAllDistances();
        } else {
          _proximityTimer?.cancel();
        }
      });
    }
    _listenForGameCompletion();
  }

  void _listenForGameCompletion() {
    final eventId = currentGame.latestEvent.id;
    if (eventId.isEmpty || eventId == _subscribedEventId) return;
    _subscribedEventId = eventId;
    _gameCompletionHandled = false;
    _eventSub?.cancel();
    _eventSub = FirestoreServices.I.eventStream(eventId).listen((event) async {
      if (event.status != 2 || _gameCompletionHandled) return;
      _gameCompletionHandled = true;
      _eventSub?.cancel();

      // Get remaining cards from database
      final updatedPlayer = await FirestoreServices.I.getGamePlayer(
        currentGame.game.pokerId,
        currentGame.game.userId,
      );
      if (updatedPlayer.userId.isNotEmpty) {
        currentGame.game = updatedPlayer;
      }

      if (!mounted) return;

      // 1. Info popup — game completed by organizer
      await Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.secondaryDark, MyColors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: MyColors.primary.withValues(alpha: 0.50),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag_rounded,
                    color: MyColors.primary,
                    size: 30.sp,
                  ),
                  SizedBox(height: 2.h),
                  text_widget(
                    "Game Completed!",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.5.h),
                  text_widget(
                    "The organizer has completed the Poker Run. Your remaining cards have been filled and your hand is ready!",
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.80),
                    textAlign: TextAlign.center,
                    height: 1.4,
                  ),
                  SizedBox(height: 3.h),
                  customButon(
                    onTap: () {
                      Get.back();
                    },
                    btnText: "See My Hand",
                    fontSize: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      if (!mounted) return;

      // 2. Poker result dialog
      await showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (ctx) => const PokerResultDialog(),
      );

      Get.offAll(() => const HomePage());
    });
  }

  @override
  void dispose() {
    _proximityTimer?.cancel();
    _eventSub?.cancel();
    super.dispose();
  }

  void randomCard() {
    int number = ran.getNextIndex();
    if (currentGame.game.cards.contains(number)) {
      randomCard();
    } else {
      currentGame.game.cards.add(number);
    }
  }

  SponsorsModel _pickSponsorFor(int actualStopIdx) {
    final enabled = sponsorLinks.where((s) => s.enable);
    final stopSpecific = enabled
        .where((s) => s.stop.isNotEmpty && s.stop.contains(actualStopIdx))
        .toList();
    if (stopSpecific.isNotEmpty) {
      stopSpecific.shuffle();
      return stopSpecific.first;
    }

    return SponsorsModel()
      ..link = defaultSponsor
      ..name = "default";
  }

  // Computes the circular route starting from [startStop].
  // startStop=4  →  [4, 5, 1, 2, 3]
  List<int> _computeSequence(int startStop) {
    const all = [1, 2, 3, 4, 5];
    final idx = all.indexOf(startStop);
    if (idx < 0) return List.from(all);
    return [...all.sublist(idx), ...all.sublist(0, idx)];
  }

  Future<void> _showFirstStopConfirm(int lockStop) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SliderConfirmSheet(
        onConfirmed: () async {
          _picking = true;
          try {
            EasyLoading.show(status: "Processing...");
            currentGame.game.routeSequence = _computeSequence(lockStop);
            if (currentGame.game.currentStop == 0) {
              currentGame.game.currentStop = 1;
            }
            await FirestoreServices.I.updateGamePlayer(currentGame.game);
            EasyLoading.dismiss();
          } finally {
            _picking = false;
          }
          if (mounted) setState(() {});
        },
      ),
    );
  }

  // True only between leaving initial point and the user confirming their first stop.
  // currentStop may still be 0 if Firestore write from schedule_poker hasn't completed.
  // Shotgun only — non-shotgun runs follow a fixed sequential route with no
  // first-stop selection (routeSequence is pre-filled in schedule_poker).
  bool get _isFirstStopPhase =>
      currentGame.latestEvent.isShotgun &&
      currentGame.game.routeSequence.isEmpty &&
      (currentGame.game.currentStop == 0 || currentGame.game.currentStop == 1);

  // Maps the position counter (currentStop 1–5) to the real stops[] index.
  // currentStop == 6 falls through to 6 (final stop).
  int get _actualIdx {
    final seq = currentGame.game.routeSequence;
    final pos = currentGame.game.currentStop;
    if (seq.isEmpty || pos < 1 || pos > seq.length) return pos;
    return seq[pos - 1];
  }

  // Label for the openMaps "from" field — cosmetic only.
  String get _prevStopName {
    if (stopNumber <= 1) return currentGame.latestEvent.stops[0].name;
    final seq = currentGame.game.routeSequence;
    if (seq.isEmpty || stopNumber - 2 >= seq.length) {
      return currentGame.latestEvent.stops[0].name;
    }
    return currentGame.latestEvent.stops[seq[stopNumber - 2]].name;
  }

  // Fires off parallel distance calculations to all 5 intermediate stops.
  void _refreshAllDistances() {
    if (_calculatingAllDistances) return;
    // GPS hasn't fixed yet — retry in 2 s instead of calculating from (0,0)
    if (currentUser.location.latitude == 0.0 &&
        currentUser.location.longitude == 0.0) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isFirstStopPhase) _refreshAllDistances();
      });
      return;
    }
    _calculatingAllDistances = true;
    int done = 0;
    for (int i = 1; i <= 5; i++) {
      calculateDistance(
        currentUser.location.latitude,
        currentUser.location.longitude,
        currentGame.latestEvent.stops[i].stopLocation.latitude,
        currentGame.latestEvent.stops[i].stopLocation.longitude,
      ).then((d) {
        if (!mounted) return;
        _allDistances[i] = d;
        done++;
        if (done == 5) {
          _calculatingAllDistances = false;
          _updateNearestStop();
        }
      });
    }
  }

  // After all distances arrive: finds overall nearest + nearest within 0.062 mi.
  // Updates state so the card re-renders automatically.
  void _updateNearestStop() {
    int? inRadius;
    double inRadiusDist = double.infinity;

    for (int i = 1; i <= 5; i++) {
      final d = _allDistances[i] ?? 99.0;
      if (d < miles && d < inRadiusDist) {
        inRadiusDist = d;
        inRadius = i;
      }
    }

    if (mounted) {
      setState(() {
        _nearestInRadius = inRadius;
      });
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    _listenForGameCompletion();
    stopNumber = currentGame.game.currentStop;

    if (_isFirstStopPhase) {
      return _buildLocatingView();
    }

    final actualIdx = _actualIdx;
    stopsModel = currentGame.latestEvent.stops[actualIdx];
    finalUrl = normalizeUrl(stopsModel.sponserLink);
    SponsorsModel? fallbackSponsor;
    String fallbackSponsorUrl = "";
    if (finalUrl.isEmpty) {
      if (!enableAds) {
        fallbackSponsor = _pickSponsorFor(actualIdx);
        fallbackSponsorUrl = normalizeUrl(fallbackSponsor.link);
      }
    }

    calculateDistance(
      currentUser.location.latitude,
      currentUser.location.longitude,
      stopsModel.stopLocation.latitude,
      stopsModel.stopLocation.longitude,
    ).then((value) {
      distance = value;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() {});
      });
    });

    return _buildNormalView(context, fallbackSponsor, fallbackSponsorUrl);
  }

  // ── Shared AppBar ────────────────────────────────────────────────────────

  AppBar _buildAppBar({required bool showLeaveAtResult}) {
    return AppBar(
      backgroundColor: Colors.white10,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: onPress(
                ontap: () {
                  Get.to(() => const AllHandsPage());
                },
                child: text_widget(
                  "SEE HAND",
                  color: MyColors.primary,
                  maxline: 1,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            flex: 2,
            child: text_widget(
              currentGame.latestEvent.pokerName.capitalize!,
              fontSize: 17.sp,
              textAlign: TextAlign.center,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
              maxline: 1,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: onPress(
                ontap: () async {
                  if (showLeaveAtResult) {
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (ctx) => const PokerResultDialog(),
                    );
                    Get.offAll(() => const HomePage());
                  } else {
                    showPopup(
                      context,
                      "If you exit this game, you will lose all progress and must re-register to play this event?",
                      PopupActionsButtons.cancel,
                      PopupActionsButtons.exit,
                      () => Get.back(),
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
                child: text_widget(
                  showLeaveAtResult ? "LEAVE" : "EXIT",
                  color: Colors.redAccent,
                  maxline: 1,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(height: 2, color: Colors.white12),
      ),
    );
  }

  // ── Locating spinner (shown while first distance batch is in-flight) ─────

  Widget _buildLocatingView() {
    final inRadius = _nearestInRadius;
    final stop = inRadius != null
        ? currentGame.latestEvent.stops[inRadius]
        : null;
    final dist = inRadius != null ? (_allDistances[inRadius] ?? 99.0) : null;

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
          appBar: _buildAppBar(showLeaveAtResult: false),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Animated icon + instructions ──────────────────────────
                      Spacer(flex: 2),
                      _PulsingLocationIcon(color: MyColors.primary),
                      SizedBox(height: 3.h),
                      text_widget(
                        "Go to your first stop",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primary,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 0.8.h),
                      text_widget(
                        "We'll detect it automatically\nonce you arrive.",
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.55),
                        textAlign: TextAlign.center,
                        height: 1.55,
                      ),
                      // ── Stop card — only when within 0.062 mi ─────────────────
                      if (stop != null && dist != null) ...[
                        SizedBox(height: 3.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.40),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w,
                                      vertical: 0.35.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.withValues(
                                          alpha: 0.45,
                                        ),
                                      ),
                                    ),
                                    child: text_widget(
                                      "You're Here!",
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w,
                                      vertical: 0.35.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.withValues(
                                          alpha: 0.40,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          RemixIcons.route_line,
                                          size: 12.sp,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 1.w),
                                        text_widget(
                                          "${dist.toStringAsFixed(2)} mi",
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.greenAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    RemixIcons.map_pin_fill,
                                    color: Colors.redAccent,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text_widget(
                                          stop.name,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          maxline: 1,
                                        ),
                                        SizedBox(height: 0.3.h),
                                        text_widget(
                                          stop.address,
                                          fontSize: 12.5.sp,
                                          color: Colors.white.withValues(
                                            alpha: 0.60,
                                          ),
                                          height: 1.35,
                                          maxline: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.w),
                                child: Divider(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              SizedBox(height: 1.2.h),
                              customButon(
                                btnText: "I'm at my first stop!",
                                onTap: () async {
                                  if (_picking) return;
                                  final lockStop = _nearestInRadius;
                                  if (lockStop == null) return;
                                  await _showFirstStopConfirm(lockStop);
                                },
                                fontSize: 17,
                              ),
                            ],
                          ),
                        ),
                      ],
                      Spacer(flex: 2),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.w),
                  child: customButon(
                    btnText: "See Map",
                    onTap: () async {
                      Get.to(
                        RouteMapView(
                          currentGame.latestEvent,
                          routeSequence: currentGame.game.routeSequence,
                        ),
                      );
                    },
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Normal stop view (position 1–6 of the route) ─────────────────────────
  // stopNumber    = position in the user's route (always 1 → 2 → … → 5 → 6)
  // _actualIdx    = the real stops[] index for that position
  // stopsModel    = actual stop data (name, address, sponsor, coords)

  Widget _buildNormalView(
    BuildContext context,
    SponsorsModel? fallbackSponsor,
    String fallbackSponsorUrl,
  ) {
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
          appBar: _buildAppBar(showLeaveAtResult: stopNumber == 6),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.5.h),

                    // ── Stop header + progress dots ───────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: MyColors.primary.withValues(
                                      alpha: 0.40,
                                    ),
                                  ),
                                ),
                                child: text_widget(
                                  "Stop $stopNumber of ${currentGame.latestEvent.stops.length - 1}",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.primary,
                                ),
                              ),
                              Expanded(
                                child: text_widget(
                                  "Next Stop",
                                  textAlign: TextAlign.center,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w600,
                                  maxline: 1,
                                  color: MyColors.primary,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  currentGame.latestEvent.stops.length - 1,
                                  (i) {
                                    final active = i < stopNumber;
                                    final current = i == stopNumber - 1;
                                    return Container(
                                      margin: EdgeInsets.only(left: 1.w),
                                      width: current ? 3.w : 1.8.w,
                                      height: 1.8.w,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? MyColors.primary
                                            : Colors.white.withValues(
                                                alpha: 0.25,
                                              ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.8.h),
                          text_widget(
                            stopsModel.name,
                            color: Colors.white,
                            maxline: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: .5.h),

                    if (finalUrl.isNotEmpty ||
                        fallbackSponsorUrl.isNotEmpty) ...[
                      // ── Sponsor chip ──────────────────────────────────────
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
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w,
                              vertical: 0.8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.campaign_outlined,
                                  color: MyColors.white.withValues(alpha: 0.55),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: text_widget(
                                    "Sponsored by ${(finalUrl.isNotEmpty ? stopsModel.sponserName : (fallbackSponsor?.name ?? stopsModel.sponserName)).capitalize}",
                                    color: Colors.white.withValues(alpha: 0.75),
                                    maxline: 1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.5.sp,
                                  ),
                                ),
                                if (finalUrl.isNotEmpty ||
                                    fallbackSponsorUrl.isNotEmpty)
                                  Icon(
                                    RemixIcons.external_link_line,
                                    color: MyColors.primary,
                                    size: 15.sp,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],

                    // ── WebView / Ad ──────────────────────────────────────
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
                              height: 53.h,
                              isMedium: true,
                              radius: 0,
                            ),
                    ),

                    SizedBox(height: 1.h),

                    // ── Address + distance card ───────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              RemixIcons.map_pin_2_line,
                              color: distance < miles
                                  ? Colors.green.withValues(alpha: 0.75)
                                  : MyColors.red.withValues(alpha: 0.75),
                              size: 18.sp,
                            ),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: text_widget(
                                stopsModel.address,
                                color: Colors.white.withValues(alpha: 0.85),
                                maxline: 2,
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.8.h,
                              ),
                              decoration: BoxDecoration(
                                color: distance < miles
                                    ? Colors.green.withValues(alpha: 0.20)
                                    : MyColors.secondary.withValues(
                                        alpha: 0.18,
                                      ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: distance < miles
                                      ? Colors.green.withValues(alpha: 0.75)
                                      : MyColors.red.withValues(alpha: 0.75),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  text_widget(
                                    distance.toStringAsFixed(2),
                                    textAlign: TextAlign.center,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: distance < miles
                                        ? Colors.greenAccent
                                        : MyColors.secondary,
                                  ),
                                  text_widget(
                                    "miles",
                                    textAlign: TextAlign.center,
                                    fontSize: 12.5.sp,
                                    color: distance < miles
                                        ? Colors.greenAccent.withValues(
                                            alpha: 0.75,
                                          )
                                        : MyColors.secondary.withValues(
                                            alpha: 0.75,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Navigate + Card action buttons ────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: onPress(
                        ontap: () {
                          // Shotgun stop 1: player is already at their chosen
                          // first stop, so the button previews the route.
                          // Non-shotgun stop 1: the first stop is a real
                          // destination to navigate to from the start point.
                          if (stopNumber == 1 &&
                              currentGame.latestEvent.isShotgun) {
                            Get.to(
                              RouteMapView(
                                currentGame.latestEvent,
                                routeSequence: currentGame.game.routeSequence,
                              ),
                            );
                          } else {
                            openMaps(
                              context,
                              stopsModel.name,
                              stopsModel.stopLocation.latitude,
                              stopsModel.stopLocation.longitude,
                              _prevStopName,
                              currentUser.location.latitude,
                              currentUser.location.longitude,
                            );
                          }
                        },
                        child: Image.asset(
                          stopNumber == 1
                              ? (currentGame.latestEvent.isShotgun
                                    ? OtherButtons.previewRoute
                                    : OtherButtons.navigate1)
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
                                builder: (ctx) => const PokerResultDialog(),
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

// ── Animated pulsing location pin ────────────────────────────────────────────

class _PulsingLocationIcon extends StatefulWidget {
  final Color color;
  const _PulsingLocationIcon({required this.color});

  @override
  State<_PulsingLocationIcon> createState() => _PulsingLocationIconState();
}

class _PulsingLocationIconState extends State<_PulsingLocationIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);

    _scale = Tween<double>(
      begin: 1.0,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0.55,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, _) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: _opacity.value),
                ),
              ),
            ),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.18),
              border: Border.all(
                color: widget.color.withValues(alpha: 0.60),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.location_pin, size: 30, color: MyColors.red),
          ),
        ],
      ),
    );
  }
}

class _SliderConfirmSheet extends StatefulWidget {
  final Future<void> Function() onConfirmed;
  const _SliderConfirmSheet({required this.onConfirmed});

  @override
  State<_SliderConfirmSheet> createState() => _SliderConfirmSheetState();
}

class _SliderConfirmSheetState extends State<_SliderConfirmSheet> {
  double _dragPos = 0;
  bool _confirmed = false;
  static const double _thumbSize = 60;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.secondaryDark, MyColors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: MyColors.primary.withValues(alpha: 0.50),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.5.h),
          Icon(
            RemixIcons.map_pin_user_fill,
            color: MyColors.primary,
            size: 30.sp,
          ),
          SizedBox(height: 2.h),
          text_widget(
            "Are you sure that you are at the first Poker run stop after your designated shotgun start hole?",
            fontSize: 17.sp,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxDrag = constraints.maxWidth - _thumbSize;
              return GestureDetector(
                onHorizontalDragUpdate: (d) {
                  if (_confirmed) return;
                  setState(() {
                    _dragPos = (_dragPos + d.delta.dx).clamp(0, maxDrag);
                  });
                  if (_dragPos >= maxDrag - 4) {
                    _confirmed = true;
                    Navigator.of(context).pop();
                    widget.onConfirmed();
                  }
                },
                onHorizontalDragEnd: (_) {
                  if (!_confirmed) setState(() => _dragPos = 0);
                },
                child: Container(
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(_thumbSize / 2),
                    border: Border.all(
                      color: MyColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        width: _dragPos + _thumbSize,
                        decoration: BoxDecoration(
                          color: MyColors.primary,
                          borderRadius: BorderRadius.circular(_thumbSize / 2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 5.w),
                        child: Center(
                          child: text_widget(
                            "Slide to confirm that I'm at 1st stop →",
                            fontSize: 15.sp,
                            color: MyColors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        left: _dragPos,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: _thumbSize,
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.primary.withValues(alpha: 0.45),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.black87,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          onPress(
            ontap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 1),
                borderRadius: BorderRadius.circular(10.w),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),
              child: text_widget(
                "No, I am not at my 1st stop",
                fontSize: 15.sp,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
        ],
      ),
    );
  }
}
