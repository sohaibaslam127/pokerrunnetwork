import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/transaction.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/services/stripeServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerSponsers extends StatefulWidget {
  EventModel eventModel;
  PokerSponsers(this.eventModel, {super.key});

  @override
  State<PokerSponsers> createState() => _PokerSponsersState();
}

class _PokerSponsersState extends State<PokerSponsers> {
  static const Map<int, double> _paidSlotPrices = {2: 2.99, 4: 1.99, 6: 0.99};

  late final List<TextEditingController> _nameControllers;
  late final List<TextEditingController> _linkControllers;

  final Set<int> _unlockedPaidSlots = {};
  final Set<int> _preExistingUnlockedSlots = {};

  @override
  void initState() {
    super.initState();
    _nameControllers = List.generate(
      6,
      (i) => TextEditingController(
        text: widget.eventModel.stops[i + 1].sponserName,
      ),
    );
    _linkControllers = List.generate(
      6,
      (i) => TextEditingController(
        text: widget.eventModel.stops[i + 1].sponserLink,
      ),
    );

    for (final slot in _paidSlotPrices.keys) {
      final stop = widget.eventModel.stops[slot];
      if (stop.sponserName.trim().isNotEmpty ||
          stop.sponserLink.trim().isNotEmpty) {
        _unlockedPaidSlots.add(slot);
        _preExistingUnlockedSlots.add(slot);
      }
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final c in _linkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Set<int> get _newlyUnlockedSlots =>
      _unlockedPaidSlots.difference(_preExistingUnlockedSlots);

  double get _unlockedTotal => _newlyUnlockedSlots.fold<double>(
    0,
    (sum, slot) => sum + (_paidSlotPrices[slot] ?? 0),
  );

  double get _discountRate {
    final count = _newlyUnlockedSlots.length;
    if (count >= 3) return 0.25;
    if (count >= 2) return 0.10;
    return 0.0;
  }

  double get _discountAmount => _unlockedTotal * _discountRate;

  double get _discountedTotal => _unlockedTotal - _discountAmount;

  bool _isUnlocked(int slotNumber) =>
      !_paidSlotPrices.containsKey(slotNumber) ||
      _unlockedPaidSlots.contains(slotNumber);

  Widget _copyPasteSuffix(TextEditingController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final hasText = controller.text.trim().isNotEmpty;
        return onPress(
          ontap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (hasText) {
              await Clipboard.setData(ClipboardData(text: controller.text));
              if (!mounted) return;
              toast(context, "Copied", "Copied to clipboard", type: 0);
            } else {
              final data = await Clipboard.getData(Clipboard.kTextPlain);
              final pasted = data?.text ?? "";
              if (pasted.isEmpty) return;
              controller.text = pasted;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          child: Icon(
            hasText ? Icons.copy_rounded : Icons.content_paste_rounded,
            size: 2.2.h,
            color: Color(0xff6C7278),
          ),
        );
      },
    );
  }

  String _ordinalSuffix(int number) {
    switch (number) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  String _ordinalWord(int number) {
    switch (number) {
      case 1:
        return "First";
      case 2:
        return "Second";
      case 3:
        return "Third";
      case 4:
        return "Fourth";
      case 5:
        return "Fifth";
      case 6:
        return "Final";
      default:
        return "$number";
    }
  }

  Future<bool> _chargeUnlockedSlots() async {
    final amount = _discountedTotal;
    if (amount <= 0) return true;

    final txn = TransactionModel()
      ..eventId = widget.eventModel.id
      ..eventName = widget.eventModel.pokerName
      ..eventCountryCode = widget.eventModel.countryCode
      ..organizerId = widget.eventModel.ownerId
      ..organizerName = widget.eventModel.ownerName
      ..userId = currentUser.id
      ..userName = currentUser.name
      ..userAccountEmail = currentUser.email
      ..totalAmount = amount
      ..transactionType = 1
      ..transactionStatus = 0
      ..date = DateTime.now();

    final success = await StripeServices.I.initPaymentSheet(
      context,
      txn,
      currentUser.email,
      "USD",
      amount,
    );

    if (!success) return false;

    txn.transactionStatus = 1;
    await FirestoreServices.I.setTransaction(txn);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final total = _discountedTotal;
    final discount = _discountRate;
    final btnLabel = widget.eventModel.id == ""
        ? "Create Poker Run"
        : "Update Poker Run";
    final btnText = total > 0
        ? "$btnLabel ( \$${total.toStringAsFixed(2)} )"
        : btnLabel;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/icons/bg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),
                  Center(
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: .5.h),
                            Row(
                              children: [
                                onPress(
                                  ontap: () {
                                    Get.back();
                                  },
                                  child: Image.asset(
                                    "assets/icons/back.png",
                                    height: 3.6.h,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                text_widget(
                                  "Sponsors",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffFFF7E6),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xffF0D68C)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xffB8860B),
                                    size: 2.4.h,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text_widget(
                                          "You get 3 Free sponsorship spots. You can purchase 3 more spots. Unused spots display the Poker Run Network website / 3rd party ads.",
                                          color: Color(0xff6C5B2A),
                                          fontSize: 12.5.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                final number = index + 1;
                                final suffix = _ordinalSuffix(number);
                                final word = _ordinalWord(number);
                                final price = _paidSlotPrices[number];
                                final isPaid = price != null;
                                final unlocked = _isUnlocked(number);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        text_widget(
                                          number == 6
                                              ? "Final Sponsor"
                                              : "$number$suffix Sponsor",
                                          color: Color(0xff6C7278),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(width: 2.w),
                                        if (isPaid)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2.w,
                                              vertical: 0.3.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: unlocked
                                                  ? Color(0xffE6F4EA)
                                                  : Color(0xffFDECEC),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: text_widget(
                                              unlocked
                                                  ? (_preExistingUnlockedSlots
                                                            .contains(number)
                                                        ? "Purchased"
                                                        : "Unlocked")
                                                  : "\$${price.toStringAsFixed(2)}",
                                              color: unlocked
                                                  ? Color(0xff137333)
                                                  : Color(0xffB00020),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        // else
                                        //   Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 2.w,
                                        //       vertical: 0.3.h,
                                        //     ),
                                        //     decoration: BoxDecoration(
                                        //       color: Color(0xffE8F0FE),
                                        //       borderRadius:
                                        //           BorderRadius.circular(6),
                                        //     ),
                                        //     child: text_widget(
                                        //       "Free",
                                        //       color: MyColors.primary,
                                        //       fontSize: 11.5.sp,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        Spacer(),
                                        text_widget(
                                          "*optional ",
                                          color: Colors.red.shade200,
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.8.h),
                                    if (isPaid && !unlocked)
                                      _LockedSlotCard(
                                        price: price,
                                        onUnlock: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          setState(() {
                                            _unlockedPaidSlots.add(number);
                                          });
                                        },
                                      )
                                    else ...[
                                      textFieldWithPrefixSuffuxIconAndHintText(
                                        "Name of $word Sponsor",
                                        fillColor: Colors.white,
                                        mainTxtColor: Colors.black,
                                        radius: 12,
                                        controller: _nameControllers[index],
                                        bColor: Color(0xffEDF1F3),
                                        hintColor: Color(0xff868686),
                                        pColor: MyColors.primary,
                                        customSuffix: _copyPasteSuffix(
                                          _nameControllers[index],
                                        ),
                                      ),
                                      SizedBox(height: 1.2.h),
                                      textFieldWithPrefixSuffuxIconAndHintText(
                                        "www.sponsorwebsite.com",
                                        fillColor: Colors.white,
                                        mainTxtColor: Colors.black,
                                        radius: 12,
                                        controller: _linkControllers[index],
                                        bColor: Color(0xffEDF1F3),
                                        hintColor: Color(0xff868686),
                                        pColor: MyColors.primary,
                                        customSuffix: _copyPasteSuffix(
                                          _linkControllers[index],
                                        ),
                                      ),
                                      if (isPaid &&
                                          unlocked &&
                                          !_preExistingUnlockedSlots.contains(
                                            number,
                                          )) ...[
                                        SizedBox(height: 0.8.h),
                                        onPress(
                                          ontap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              _unlockedPaidSlots.remove(number);
                                              _nameControllers[index].clear();
                                              _linkControllers[index].clear();
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.lock_outline,
                                                size: 1.8.h,
                                                color: Color(0xff6C7278),
                                              ),
                                              SizedBox(width: 1.w),
                                              text_widget(
                                                "Remove this paid slot",
                                                color: Color(0xff6C7278),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                    SizedBox(height: 2.h),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: .5.h),
                            customButon(
                              isIcon: false,
                              btnText: btnText,
                              fontSize: 16.6.sp,
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();

                                for (final slot in _unlockedPaidSlots) {
                                  final i = slot - 1;
                                  if (_nameControllers[i].text.trim().isEmpty ||
                                      _linkControllers[i].text.trim().isEmpty) {
                                    toast(
                                      context,
                                      "Sponsor required",
                                      "Please enter the name and website for every paid sponsor slot.",
                                      type: 1,
                                    );
                                    return;
                                  }
                                }

                                for (int i = 0; i < 6; i++) {
                                  final slot = i + 1;
                                  if (_isUnlocked(slot)) {
                                    widget.eventModel.stops[slot].sponserName =
                                        _nameControllers[i].text;
                                    widget.eventModel.stops[slot].sponserLink =
                                        _linkControllers[i].text;
                                  } else {
                                    widget.eventModel.stops[slot].sponserName =
                                        "";
                                    widget.eventModel.stops[slot].sponserLink =
                                        "";
                                  }
                                }

                                if (_unlockedTotal > 0) {
                                  EasyLoading.show(
                                    status: "Processing payment...",
                                  );
                                  final paid = await _chargeUnlockedSlots();
                                  EasyLoading.dismiss();
                                  if (!paid) {
                                    toast(
                                      context,
                                      "Payment",
                                      "Payment failed. Please try again.",
                                      type: 1,
                                    );
                                    return;
                                  }
                                }

                                EasyLoading.show();
                                bool result = await FirestoreServices.I
                                    .setEvent(
                                      context,
                                      widget.eventModel,
                                      null,
                                      false,
                                    );
                                EasyLoading.dismiss();
                                if (result) {
                                  Get.close(5);
                                  if (widget.eventModel.id.isEmpty) {
                                    toast(
                                      context,
                                      "Event Created",
                                      "Event created successfully",
                                      type: 0,
                                    );
                                  } else {
                                    toast(
                                      context,
                                      "Event Update",
                                      "Event updated successfully",
                                      type: 0,
                                    );
                                  }
                                } else {
                                  toast(
                                    context,
                                    "Create Event",
                                    "Something went wrong",
                                    type: 1,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LockedSlotCard extends StatelessWidget {
  final double price;
  final VoidCallback onUnlock;

  const _LockedSlotCard({required this.price, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      decoration: BoxDecoration(
        color: Color(0xffF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffEDF1F3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Color(0xff6C7278), size: 2.6.h),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text_widget(
                  "Paid sponsor slot",
                  color: Color(0xff111827),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 0.3.h),
                text_widget(
                  "Unlock for \$${price.toStringAsFixed(2)}",
                  color: Color(0xff6C7278),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          onPress(
            ontap: onUnlock,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: text_widget(
                "Unlock",
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
