import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/poker_Stops.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerRoute extends StatefulWidget {
  EventModel eventModel;
  PokerRoute(this.eventModel, {super.key});

  @override
  State<PokerRoute> createState() => _PokerRouteState();
}

class _PokerRouteState extends State<PokerRoute> {
  TextEditingController startingPointController = TextEditingController();
  TextEditingController finalDestinationController = TextEditingController();
  TextEditingController startingPointAddressController =
      TextEditingController();
  TextEditingController finalDestinationAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    startingPointController.text = widget.eventModel.stops[0].name;
    finalDestinationController.text = widget.eventModel.stops[6].name;
    startingPointAddressController.text = widget.eventModel.stops[0].address;
    finalDestinationAddressController.text = widget.eventModel.stops[6].address;
  }

  @override
  void dispose() {
    super.dispose();
    startingPointController.dispose();
    finalDestinationController.dispose();
    startingPointAddressController.dispose();
    finalDestinationAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/icons/bbg.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: onPress(
            ontap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 90.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 88.w,
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
                                      "Poker Run Route",
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.5.h),
                                text_widget(
                                  "Starting point",
                                  color: Color(0xff6C7278),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 0.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  'Name of Starting point'.tr,
                                  controller: startingPointController,
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                                SizedBox(height: 1.3.h),
                                onPress(
                                  ontap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showPlacePicker(context).then(
                                      (loc) => loc.latLng == null
                                          ? toast(
                                              context,
                                              "Location",
                                              "Select Address of the Valid Location",
                                              type: 1,
                                            )
                                          : () {
                                              startingPointAddressController
                                                      .text =
                                                  loc.formattedAddress ?? "";
                                              widget
                                                  .eventModel
                                                  .stops[0]
                                                  .stopLocation = GeoPoint(
                                                loc.latLng!.latitude,
                                                loc.latLng!.longitude,
                                              );
                                              setState(() {});
                                            }(),
                                    );
                                  },
                                  child:
                                      textFieldWithPrefixSuffuxIconAndHintText(
                                        "Select Address of Starting Point".tr,
                                        line: 2,
                                        controller:
                                            startingPointAddressController,
                                        fillColor: Colors.white,
                                        mainTxtColor: Colors.black,
                                        radius: 12,
                                        bColor: Color(0xffEDF1F3),
                                        hintColor: Color(0xff868686),
                                        onChange: () {
                                          setState(() {});
                                        },
                                        pColor: MyColors.primary,
                                        enable: startingPointAddressController
                                            .text
                                            .trim()
                                            .isNotEmpty,
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                text_widget(
                                  "Final Destination",
                                  color: Color(0xff6C7278),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 0.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  'Name of Final destination'.tr,
                                  controller: finalDestinationController,
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                                SizedBox(height: 1.3.h),
                                onPress(
                                  ontap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showPlacePicker(context).then(
                                      (loc) => loc.latLng == null
                                          ? toast(
                                              context,
                                              "Location",
                                              "Select Address of the Valid Location",
                                              type: 1,
                                            )
                                          : () {
                                              finalDestinationAddressController
                                                      .text =
                                                  loc.formattedAddress ?? "";
                                              widget
                                                  .eventModel
                                                  .stops[6]
                                                  .stopLocation = GeoPoint(
                                                loc.latLng!.latitude,
                                                loc.latLng!.longitude,
                                              );
                                              setState(() {});
                                            }(),
                                    );
                                  },
                                  child:
                                      textFieldWithPrefixSuffuxIconAndHintText(
                                        'Select Address of Final Destination'
                                            .tr,
                                        controller:
                                            finalDestinationAddressController,
                                        enable:
                                            finalDestinationAddressController
                                                .text
                                                .trim()
                                                .isNotEmpty,
                                        line: 2,
                                        onChange: () {
                                          setState(() {});
                                        },
                                        fillColor: Colors.white,
                                        mainTxtColor: Colors.black,
                                        radius: 12,
                                        bColor: Color(0xffEDF1F3),
                                        hintColor: Color(0xff868686),
                                        pColor: MyColors.primary,
                                      ),
                                ),
                                SizedBox(height: 2.5.h),
                                customButon(
                                  isIcon: false,
                                  btnText: "Continue to Stops",
                                  icon: "assets/icons/p1.png",
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (startingPointAddressController.text
                                            .trim()
                                            .isEmpty ||
                                        finalDestinationAddressController.text
                                            .trim()
                                            .isEmpty ||
                                        startingPointController.text
                                            .trim()
                                            .isEmpty ||
                                        finalDestinationController.text
                                            .trim()
                                            .isEmpty) {
                                      toast(
                                        context,
                                        "Info",
                                        "Please fill all the required fields.",
                                      );
                                      return;
                                    }
                                    widget.eventModel.stops[0].name =
                                        startingPointController.text;
                                    widget.eventModel.stops[6].name =
                                        finalDestinationController.text;

                                    widget.eventModel.stops[0].address =
                                        startingPointAddressController.text;
                                    widget.eventModel.stops[6].address =
                                        finalDestinationAddressController.text;

                                    Get.to(PokerStops(widget.eventModel));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
