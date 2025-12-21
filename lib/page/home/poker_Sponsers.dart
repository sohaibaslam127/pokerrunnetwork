import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
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
  TextEditingController firstStop = TextEditingController();
  TextEditingController secondStop = TextEditingController();
  TextEditingController thirdStop = TextEditingController();
  TextEditingController fourthStop = TextEditingController();
  TextEditingController fifthStop = TextEditingController();

  TextEditingController firstStopWeb = TextEditingController();
  TextEditingController secondStopWeb = TextEditingController();
  TextEditingController thirdStopWeb = TextEditingController();
  TextEditingController fourthStopWeb = TextEditingController();
  TextEditingController fifthStopWeb = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstStop.dispose();
    secondStop.dispose();
    thirdStop.dispose();
    fourthStop.dispose();
    fifthStop.dispose();
    fifthStopWeb.dispose();
    secondStopWeb.dispose();
    thirdStopWeb.dispose();
    fourthStopWeb.dispose();
    firstStopWeb.dispose();
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
                            SizedBox(height: 2.5.h),
                            ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
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
                                String word;
                                switch (number) {
                                  case 1:
                                    word = "First";
                                    break;
                                  case 2:
                                    word = "Second";
                                    break;
                                  case 3:
                                    word = "Third";
                                    break;
                                  case 4:
                                    word = "Fourth";
                                    break;
                                  case 5:
                                    word = "Fifth";
                                    break;
                                  default:
                                    word = "$number";
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        text_widget(
                                          "$number$suffix Sponsor",
                                          color: Color(0xff6C7278),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Spacer(),
                                        text_widget(
                                          "*optional ",
                                          color: Colors.red.shade200,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.8.h),
                                    textFieldWithPrefixSuffuxIconAndHintText(
                                      "Name of $word Sponsor",
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
                                    SizedBox(height: 1.2.h),
                                    textFieldWithPrefixSuffuxIconAndHintText(
                                      "www.sponsorwebsite.com",
                                      fillColor: Colors.white,
                                      mainTxtColor: Colors.black,
                                      radius: 12,
                                      controller: index == 0
                                          ? firstStopWeb
                                          : index == 1
                                          ? secondStopWeb
                                          : index == 2
                                          ? thirdStopWeb
                                          : index == 3
                                          ? fourthStopWeb
                                          : fifthStopWeb,
                                      bColor: Color(0xffEDF1F3),
                                      hintColor: Color(0xff868686),
                                      pColor: MyColors.primary,
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: .5.h),
                            customButon(
                              isIcon: false,
                              btnText: "Create Poker Run",
                              icon: "assets/icons/p1.png",
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                widget.eventModel.stops[1].sponserName =
                                    firstStop.text;
                                widget.eventModel.stops[2].sponserName =
                                    secondStop.text;
                                widget.eventModel.stops[3].sponserName =
                                    thirdStop.text;
                                widget.eventModel.stops[4].sponserName =
                                    fourthStop.text;
                                widget.eventModel.stops[5].sponserName =
                                    fifthStop.text;

                                widget.eventModel.stops[1].sponserLink =
                                    firstStopWeb.text;
                                widget.eventModel.stops[2].sponserLink =
                                    secondStopWeb.text;
                                widget.eventModel.stops[3].sponserLink =
                                    thirdStopWeb.text;
                                widget.eventModel.stops[4].sponserLink =
                                    fourthStopWeb.text;
                                widget.eventModel.stops[5].sponserLink =
                                    fifthStopWeb.text;
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
                                  Get.close(4);
                                  toast(
                                    context,
                                    "Event Created",
                                    "Event created successfully",
                                    type: 0,
                                  );
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
