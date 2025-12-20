import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/poker_Sponsers.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerStops extends StatefulWidget {
  EventModel eventModel;
  PokerStops(this.eventModel, {super.key});

  @override
  State<PokerStops> createState() => _PokerStopsState();
}

class _PokerStopsState extends State<PokerStops> {
  TextEditingController firstStop = TextEditingController();
  TextEditingController secondStop = TextEditingController();
  TextEditingController thirdStop = TextEditingController();
  TextEditingController fourthStop = TextEditingController();
  TextEditingController fifthStop = TextEditingController();

  TextEditingController firstStopAddress = TextEditingController();
  TextEditingController secondStopAddress = TextEditingController();
  TextEditingController thirdStopAddress = TextEditingController();
  TextEditingController fourthStopAddress = TextEditingController();
  TextEditingController fifthStopAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstStop.text = widget.eventModel.stops[1].name;
    secondStop.text = widget.eventModel.stops[2].name;
    thirdStop.text = widget.eventModel.stops[3].name;
    fourthStop.text = widget.eventModel.stops[4].name;
    fifthStop.text = widget.eventModel.stops[5].name;

    firstStopAddress.text = widget.eventModel.stops[1].address;
    secondStopAddress.text = widget.eventModel.stops[2].address;
    thirdStopAddress.text = widget.eventModel.stops[3].address;
    fourthStopAddress.text = widget.eventModel.stops[4].address;
    fifthStopAddress.text = widget.eventModel.stops[5].address;
  }

  @override
  void dispose() {
    super.dispose();
    firstStop.dispose();
    secondStop.dispose();
    thirdStop.dispose();
    fourthStop.dispose();
    fifthStop.dispose();
    fifthStopAddress.dispose();
    secondStopAddress.dispose();
    thirdStopAddress.dispose();
    fourthStopAddress.dispose();
    firstStopAddress.dispose();
  }

  @override
  Widget build(BuildContext maincontext) {
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
                                    "Poker Run Stops",
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.5.h),
                              ListView.builder(
                                itemCount: 5,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  int number = index + 1;
                                  String suffix = number == 1
                                      ? "st"
                                      : number == 2
                                      ? "nd"
                                      : number == 3
                                      ? "rd"
                                      : "th";
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text_widget(
                                        "$number$suffix Stops",
                                        color: Color(0xff6C7278),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(height: 0.5.h),
                                      textFieldWithPrefixSuffuxIconAndHintText(
                                        "Name of $number$suffix Poker Run Stop",
                                        fillColor: Colors.white,
                                        mainTxtColor: Colors.black,
                                        radius: 12,
                                        controller: index == 0
                                            ? firstStop
                                            : index == 1
                                            ? secondStop
                                            : index == 2
                                            ? thirdStop
                                            : index == 3
                                            ? fourthStop
                                            : fifthStop,
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
                                                    "Select the Valid Location",
                                                    type: 1,
                                                  )
                                                : () {
                                                    if (index == 0) {
                                                      firstStopAddress.text =
                                                          loc.formattedAddress ??
                                                          "";
                                                    } else if (index == 1) {
                                                      secondStopAddress.text =
                                                          loc.formattedAddress ??
                                                          "";
                                                    } else if (index == 2) {
                                                      thirdStopAddress.text =
                                                          loc.formattedAddress ??
                                                          "";
                                                    } else if (index == 3) {
                                                      fourthStopAddress.text =
                                                          loc.formattedAddress ??
                                                          "";
                                                    } else {
                                                      fifthStopAddress.text =
                                                          loc.formattedAddress ??
                                                          "";
                                                    }
                                                    widget
                                                            .eventModel
                                                            .stops[index]
                                                            .stopLocation =
                                                        GeoPoint(
                                                          loc.latLng!.latitude,
                                                          loc.latLng!.longitude,
                                                        );
                                                    setState(() {});
                                                  }(),
                                          );
                                        },
                                        child: textFieldWithPrefixSuffuxIconAndHintText(
                                          "Select Address of $number$suffix Poker Run Stop",
                                          fillColor: Colors.white,
                                          onChange: () {
                                            setState(() {});
                                          },
                                          controller: index == 0
                                              ? firstStopAddress
                                              : index == 1
                                              ? secondStopAddress
                                              : index == 2
                                              ? thirdStopAddress
                                              : index == 3
                                              ? fourthStopAddress
                                              : fifthStopAddress,
                                          enable: index == 0
                                              ? firstStopAddress.text
                                                    .trim()
                                                    .isNotEmpty
                                              : index == 1
                                              ? secondStopAddress.text
                                                    .trim()
                                                    .isNotEmpty
                                              : index == 2
                                              ? thirdStopAddress.text
                                                    .trim()
                                                    .isNotEmpty
                                              : index == 3
                                              ? fourthStopAddress.text
                                                    .trim()
                                                    .isNotEmpty
                                              : fifthStopAddress.text
                                                    .trim()
                                                    .isNotEmpty,
                                          line: 2,
                                          mainTxtColor: Colors.black,
                                          radius: 12,
                                          bColor: Color(0xffEDF1F3),
                                          hintColor: Color(0xff868686),
                                          pColor: MyColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: .5.h),
                              customButon(
                                isIcon: false,
                                btnText: "Continue To Sponsors",
                                icon: "assets/icons/p1.png",
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (firstStopAddress.text.trim().isEmpty ||
                                      secondStopAddress.text.trim().isEmpty ||
                                      thirdStopAddress.text.trim().isEmpty ||
                                      fourthStopAddress.text.trim().isEmpty ||
                                      fifthStopAddress.text.trim().isEmpty ||
                                      firstStop.text.trim().isEmpty ||
                                      secondStop.text.trim().isEmpty ||
                                      thirdStop.text.trim().isEmpty ||
                                      fourthStop.text.trim().isEmpty ||
                                      fifthStop.text.trim().isEmpty) {
                                    toast(
                                      context,
                                      "Info",
                                      "Please fill all the required fields.",
                                    );
                                    return;
                                  }
                                  widget.eventModel.stops[1].name =
                                      firstStop.text;
                                  widget.eventModel.stops[2].name =
                                      secondStop.text;
                                  widget.eventModel.stops[3].name =
                                      thirdStop.text;
                                  widget.eventModel.stops[4].name =
                                      fourthStop.text;
                                  widget.eventModel.stops[5].name =
                                      fifthStop.text;

                                  widget.eventModel.stops[1].address =
                                      firstStopAddress.text;
                                  widget.eventModel.stops[2].address =
                                      secondStopAddress.text;
                                  widget.eventModel.stops[3].address =
                                      thirdStopAddress.text;
                                  widget.eventModel.stops[4].address =
                                      fourthStopAddress.text;
                                  widget.eventModel.stops[5].address =
                                      fifthStopAddress.text;

                                  Get.to(PokerSponsers(widget.eventModel));
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
        ),
      ],
    );
  }
}
