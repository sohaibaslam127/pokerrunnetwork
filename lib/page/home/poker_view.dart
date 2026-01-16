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
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerDetailsView extends StatefulWidget {
  final EventModel event;
  final GamePlayerModel iamCoRider;

  const PokerDetailsView(this.event, this.iamCoRider, {super.key});

  @override
  State<PokerDetailsView> createState() => _PokerDetailsViewState();
}

class _PokerDetailsViewState extends State<PokerDetailsView> {
  // Logic variables from Old Design
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
            backgroundColor: Colors.transparent.withValues(alpha: .2),
            elevation: 0,
            leadingWidth: 8.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 3.5),
              child: onPress(
                ontap: () => Get.back(),
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 25.sp,
                  color: MyColors.white,
                ),
              ),
            ),
            title: text_widget(
              widget.event.pokerName,
           fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,

            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      text_widget(
                        widget.event.pokerName,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      SizedBox(height: 0.3.h),
              
                      text_widget(
                        "Starting date:  ${DateFormat("d MMM yyyy").format(widget.event.eventDate)}\n"
                        "Starting time:  ${DateFormat("h:mm aaa").format(widget.event.eventDate)}\n"
                        "Cost of this Poker Run:  \$${widget.event.joinFee.toStringAsFixed(2)}",
                        fontSize: 14.5.sp,
                        color: MyColors.white.withValues(alpha: 0.60),
                        height: 1.7,
                      ),
                      SizedBox(height: 2.h),
                      text_widget(
                        "Description",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      SizedBox(height: 0.3.h),
              
                      text_widget(
                        widget.event.description,
                        fontSize: 14.5.sp,
                        color: MyColors.white.withValues(alpha: 0.60),
                        height: 1.7,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text_widget(
                                  "Starting point: ${widget.event.stops[0].name}",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      SizedBox(height: 0.3.h),
              
                                text_widget(
                                  "${widget.event.stops[0].address}\n${widget.event.stops[0].sponserName == "" ? widget.event.stops[0].sponserLink : widget.event.stops[0].sponserName}",
                                  fontSize: 14.5.sp,
                                  color: MyColors.white.withValues(alpha: 0.60),
                                  height: 1.7,
                                ),
                              ],
                            ),
                          ),
                          onPress(
                            ontap: () => openMaps(
                              context,
                              widget.event.stops[0].name,
                              widget.event.stops[0].stopLocation.latitude,
                              widget.event.stops[0].stopLocation.longitude,
                            ),
                            child: Icon(
                              RemixIcons.map_pin_line,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ],
                      ),
                      if (isJoin &&
                          widget.event.changeCardFee > 0 &&
                          widget.iamCoRider.roadName.isEmpty &&
                          (widget.event.isAdditionalCard ?? false)) ...[
                        _buildCheckboxOption(
                          "Do you want the option of changing your card at each stop for \$${widget.event.changeCardFee.toStringAsFixed(2)}?",
                          isExtraCard,
                          (val) => setState(() => isExtraCard = val),
                        ),
                      ],
              
                      if (isJoin &&
                          !widget.iamCoRider.roadName.isNotEmpty &&
                          (widget.event.coRider ?? false)) ...[
                        SizedBox(height: 2.h),
                        _buildCheckboxOption(
                          "Do you want to add a co-rider for \$${widget.event.coRiderFee.toStringAsFixed(2)}?",
                          isCorider,
                          (val) => setState(() => isCorider = val),
                        ),
                        if (isCorider) ...[
                          SizedBox(height: 1.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Enter Co-rider Road Name",
                            radius: 12,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.name,
                            controller: friendName,
                          ),
                          SizedBox(height: 2.h),
                          _buildCheckboxOption(
                            "Option for co-rider to change cards for \$${widget.event.coRiderFee.toStringAsFixed(2)}?",
                            isExtraCardCorider,
                            (val) => setState(() => isExtraCardCorider = val),
                          ),
                        ],
                      ],
              
                      // --- Price Summary Table ---
                      SizedBox(height: 3.h),
                      if (widget.iamCoRider.roadName.isEmpty && isJoin) ...[
                        _priceRow("Rider", widget.event.joinFee),
                        if (isCorider)
                          _priceRow("Co-rider", widget.event.coRiderFee),
                        if (isExtraCard)
                          _priceRow(
                            "Rider Extra Cards",
                            widget.event.changeCardFee,
                          ),
                        if (isExtraCardCorider && isCorider)
                          _priceRow(
                            "Co-rider Extra Cards",
                            widget.event.changeCardFee,
                          ),
                        SizedBox(height: 1.3.h),
                        Divider(thickness: 0.2, color: Colors.white54),
                        SizedBox(height: 1.3.h),
                        Row(
                          children: [
                            text_widget(
                              "Total Paid to Organizer",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            Spacer(),
                            text_widget(
                              "\$${getAmount().toStringAsFixed(2)}",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
              
                      SizedBox(height: 2.h),
                      text_widget(
                        _getFooterText(),
                        fontSize: 15.sp,
                        color: MyColors.white.withValues(alpha: 0.60),
                        height: 1.7,
                      ),
                     
                    ],
                  ),
                ),
              ),
               SizedBox(height: 2.h),
                  onPress(
                    ontap: () => handlePrimaryAction(),
                    child: Image.asset(
                      // width: 50.w,
                      // fit: BoxFit.fill,
                      isJoin
                          ? OtherButtons.joinThisPokerRun
                          : OtherButtons.leaveThisPokerRun,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, double price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          text_widget(label, fontSize: 16.sp, color: Colors.white),
          Spacer(),
          text_widget(
            "\$${price.toStringAsFixed(2)}",
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text_widget(title, fontSize: 16.sp, color: Colors.white),
        Row(
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(true),
                activeColor: Colors.white,
                checkColor: Colors.black,
              ),
            ),
            text_widget("Yes", fontSize: 15.sp, color: Colors.white),
            SizedBox(width: 5.w),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: !value,
                onChanged: (v) => onChanged(false),
                activeColor: Colors.white,
                checkColor: Colors.black,
              ),
            ),
            text_widget("No", fontSize: 15.sp, color: Colors.white),
          ],
        ),
      ],
    );
  }

  String _getFooterText() {
    if (widget.iamCoRider.roadName.isEmpty) {
      String msg = isJoin
          ? "The registration fee for this event is \$${serviceFee.toStringAsFixed(2)} per participant.\n"
          : "";
      msg += isJoin
          ? "Would you like to continue?"
          : "Would you like to leave the Event?";
      return msg;
    } else {
      return "You have been identified as ${widget.iamCoRider.roadName}'s Co-Rider.\n"
          "Fees have been paid by the primary rider. Co-riders do not pay registration fees.";
    }
  }

  // --- Logic Functions (Ported from Old Design) ---

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
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(widget.event.pokerName),
        content: Column(
          children: [
            Text("\nDo you want to join this Poker Run?"),
            if (serviceFee != 0) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text("Registration Fee"),
                  Spacer(),
                  Text("\$${serviceFee.toStringAsFixed(2)}"),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Total"),
                  Spacer(),
                  Text("\$${serviceFee.toStringAsFixed(2)}"),
                ],
              ),
            ],
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Join"),
            onPressed: () => processPaymentAndJoin(),
          ),
        ],
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
        gameData.gameStage = 1;
        break;
      }
    }
    EasyLoading.dismiss();
    Get.back();
  }

  void showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Leave ${widget.event.pokerName}"),
        content: Text("Are you sure you want to leave this Poker Run?"),
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            child: Text("Leave", style: TextStyle(color: Colors.redAccent)),
            onPressed: () async {
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
          ),
        ],
      ),
    );
  }
}
