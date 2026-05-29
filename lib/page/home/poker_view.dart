import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pokerrunnetwork/config/colors.dart'; // Assuming path based on new design
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gameData.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/models/transaction.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/services/stripeServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pokerrunnetwork/widgets/custom_ad_widget.dart';
import 'package:pokerrunnetwork/page/home/route_map_view.dart';

class PokerDetailsView extends StatefulWidget {
  final EventModel event;
  final GamePlayerModel iamCoRider;

  const PokerDetailsView(this.event, this.iamCoRider, {super.key});

  @override
  State<PokerDetailsView> createState() => _PokerDetailsViewState();
}

class _PokerDetailsViewState extends State<PokerDetailsView> {
  bool isExtraCard = false;
  bool isExtraCardCorider = false;
  bool isCorider = false;
  bool isJoin = true;
  TextEditingController friendName = TextEditingController();

  @override
  void initState() {
    super.initState();
    isJoin = widget.event.userIds
        .where((element) => element == currentUser.id)
        .isEmpty;
    isExtraCard =
        widget.event.changeCardFee == 0 &&
        (widget.event.isAdditionalCard ?? false);
  }

  double getAmount() {
    double totalAmount = 0;
    if (isJoin) {
      totalAmount += widget.event.joinFee;
    }
    if (isExtraCard) {
      totalAmount += widget.event.changeCardFee;
    }
    if (isCorider) {
      totalAmount += widget.event.coRiderFee;
    }
    if (isCorider && isExtraCardCorider) {
      totalAmount += widget.event.changeCardFee;
    }
    return totalAmount;
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  children: [
                    SizedBox(height: 1.5.h),

                    // ── Date / time card ──────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.2.w),
                            decoration: BoxDecoration(
                              color: MyColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              RemixIcons.calendar_event_line,
                              color: MyColors.primary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text_widget(
                                  "Event Date",
                                  fontSize: 12.sp,
                                  color: MyColors.white.withValues(alpha: 0.50),
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 0.4.h),
                                text_widget(
                                  DateFormat(
                                    'EEE, dd MMM yyyy  •  h:mm a',
                                  ).format(widget.event.eventDate),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // ── Description card ──────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                RemixIcons.article_line,
                                color: MyColors.white.withValues(alpha: 0.65),
                                size: 16.sp,
                              ),
                              SizedBox(width: 2.w),
                              text_widget(
                                "Description",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: MyColors.white.withValues(alpha: 0.75),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.8.h),
                          text_widget(
                            widget.event.description,
                            fontSize: 14.sp,
                            color: MyColors.white.withValues(alpha: 0.60),
                            height: 1.6,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // ── Route card ────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                RemixIcons.route_line,
                                color: MyColors.white.withValues(alpha: 0.65),
                                size: 16.sp,
                              ),
                              SizedBox(width: 2.w),
                              text_widget(
                                "Route",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: MyColors.white.withValues(alpha: 0.75),
                              ),
                              const Spacer(),
                              onPress(
                                ontap: () => Get.to(
                                  RouteMapView(
                                    widget.event,
                                    routeSequence:
                                        currentGame.game.routeSequence,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 0.6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: MyColors.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        RemixIcons.map_2_fill,
                                        color: MyColors.primary,
                                        size: 13.sp,
                                      ),
                                      SizedBox(width: 1.5.w),
                                      text_widget(
                                        "View Map",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.4.h),
                          _routeStopRow(
                            iconWidget: Icon(
                              RemixIcons.checkbox_blank_circle_line,
                              color: Colors.white.withValues(alpha: 0.85),
                              size: 16.sp,
                            ),
                            label: "Start Point",
                            name: widget.event.stops.first.name,
                            address: widget.event.stops.first.address,
                            showLine: true,
                          ),
                          _routeStopRow(
                            iconWidget: Icon(
                              RemixIcons.map_pin_fill,
                              color: const Color(0xFFEF6C4A),
                              size: 18.sp,
                            ),
                            label: "End Point",
                            name: widget.event.stops.last.name,
                            address: widget.event.stops.last.address,
                          ),
                          SizedBox(height: 0.5.h),
                          text_widget(
                            "${widget.event.stops.length} stops total — tap View Map for the full route.",
                            fontSize: 12.sp,
                            color: MyColors.white.withValues(alpha: 0.40),
                            height: 1.4,
                          ),
                        ],
                      ),
                    ),

                    // ── Fee notice ────────────────────────────────────────
                    if (isJoin) ...[
                      SizedBox(height: 1.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.4.h,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: MyColors.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              RemixIcons.coins_line,
                              color: MyColors.primary,
                              size: 17.sp,
                            ),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: text_widget(
                                "Pay \$${widget.event.joinFee.toStringAsFixed(2)} to the organizer at the starting location to confirm your participation.",
                                fontSize: 13.5.sp,
                                color: MyColors.primary.withValues(alpha: 0.90),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 1.5.h),
                    const CustomAdInlineWidget(),
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
              onPress(
                ontap: () => handlePrimaryAction(),
                child: Image.asset(
                  isJoin
                      ? OtherButtons.joinThisPokerRun
                      : OtherButtons.leaveThisPokerRun,
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _routeStopRow({
    required Widget iconWidget,
    required String label,
    required String name,
    required String address,
    bool showLine = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 5.w,
            child: CustomPaint(
              painter: showLine ? DottedLinePainter() : null,
              child: Column(children: [iconWidget]),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 2.h : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_widget(
                    label,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white.withValues(alpha: 0.55),
                  ),
                  SizedBox(height: 0.2.h),
                  text_widget(
                    name,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  SizedBox(height: 0.2.h),
                  text_widget(
                    address,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white.withValues(alpha: 0.65),
                    height: 1.3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handlePrimaryAction() async {
    if (isJoin) {
      if (isCorider) {
        if (friendName.text.trim().isEmpty) {
          toast(
            context,
            "Co-rider Road Name",
            "Please enter your Co-rider Road Name/User Name",
          );
          return;
        }
        if (friendName.text.trim().toLowerCase() == currentUser.roadName) {
          toast(
            context,
            "Invalid Road Name",
            "You can not enter your own Road Name",
          );
          return;
        }
        bool roadUnique = await FirestoreServices.I.isRoadNameUnique(
          friendName.text.trim().toLowerCase(),
        );
        if (roadUnique) {
          toast(
            context,
            "Road Name Not found",
            "Co-rider Road Name does not exist",
          );
          return;
        }
      }
      if (widget.iamCoRider.roadName == "") {
        showJoinConfirmation();
      } else {
        await joinEventDirectly();
      }
    } else {
      showLeaveConfirmation();
    }
  }

  void showJoinConfirmation() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Join This Poker Run',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3B70),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Are You Sure You Want To Join\nThis Poker Run?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
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
                      ontap: () {
                        processPaymentAndJoin();
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

  Future<void> processPaymentAndJoin() async {
    Get.back();
    EasyLoading.show(status: "Processing", maskType: EasyLoadingMaskType.black);

    TransactionModel tranModel = TransactionModel();
    bool success = await StripeServices.I.initPaymentSheet(
      context,
      tranModel,
      currentUser.email,
      widget.event.currency.currencyCode ?? 'usd',
      serviceFee,
    );

    if (success) {
      if (serviceFee != 0) {
        tranModel.totalAmount = serviceFee;
        tranModel.eventId = widget.event.id;
        tranModel.eventName = widget.event.pokerName;
        tranModel.organizerId = widget.event.ownerId;
        tranModel.userId = currentUser.id;
        await FirestoreServices.I.setTransaction(tranModel);
      }

      await finalizeJoin();
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<void> joinEventDirectly() async {
    EasyLoading.show(status: "Joining...");
    await finalizeJoin();
  }

  Future<void> finalizeJoin() async {
    widget.event.userIds.add(currentUser.id);

    // Update Firestore
    await FirestoreServices.I.updateEvent(
      context,
      widget.event,
      true,
      isExtraCard,
      mycoRider: isCorider,
      mycoRiderName: friendName.text.trim().toLowerCase(),
      iamcoRider: widget.iamCoRider.roadName.isNotEmpty,
      isExtraCardCorider: isExtraCardCorider,
    );

    currentUser.isUser = true;
    FirestoreServices.I.updateUser();

    // Refresh Data and Navigate
    GameData gameData = GameData();
    List<EventModel> pokers = await FirestoreServices.I.getLatestEvent();
    for (EventModel poker in pokers) {
      GamePlayerModel player = await FirestoreServices.I.getGamePlayer(
        poker.id,
        currentUser.id,
      );
      if (player.currentStop < 6) {
        gameData.latestEvent = poker;
        gameData.game = player;
        break;
      }
    }
    EasyLoading.dismiss();
    Get.back();
  }

  void showLeaveConfirmation() {
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
                'Leave',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3B70),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are You Sure You Want To Leave\nThis Poker Run?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
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
                        widget.event.userIds.remove(currentUser.id);
                        await FirestoreServices.I.updateEvent(
                          context,
                          widget.event,
                          false,
                          false,
                        );
                        EasyLoading.dismiss();
                        Get.back();
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
}

Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
      Text(
        price,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double dashHeight = 4;
    double dashSpace = 4;
    double startY = 22; // Start from behind the top icon

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
