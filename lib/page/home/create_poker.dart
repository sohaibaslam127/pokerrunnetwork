import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePoker extends StatefulWidget {
  const CreatePoker({super.key});

  @override
  State<CreatePoker> createState() => _CreatePokerState();
}

class _CreatePokerState extends State<CreatePoker> {
  EventModel eventModel = EventModel();
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pokerRunCostController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController coRiderCostController = TextEditingController();
  TextEditingController additionalCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          body: onPress(
            ontap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                controller: scrollController,
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
                                    "Create a new Poker Run",
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                'Name of poker run'.tr,
                                fillColor: Colors.white,
                                controller: nameController,
                                mainTxtColor: Colors.black,
                                textInputType: TextInputType.text,
                                radius: 12,
                                bColor: Color(0xffEDF1F3),
                                hintColor: Color(0xff868686),
                                pColor: MyColors.primary,
                              ),
                              SizedBox(height: 1.3.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Description".tr,
                                fillColor: Colors.white,
                                controller: descriptionController,
                                mainTxtColor: Colors.black,
                                textInputType: TextInputType.text,
                                radius: 12,
                                line: 3,
                                bColor: Color(0xffEDF1F3),
                                hintColor: Color(0xff868686),
                                pColor: MyColors.primary,
                              ),
                              SizedBox(height: 1.3.h),
                              onPress(
                                ontap: () async {
                                  selectedDate = await pickDate(context);
                                  if (selectedDate != null) {
                                    setState(() {});
                                  }
                                },
                                child: textFieldWithPrefixSuffuxIconAndHintText(
                                  'Select Date'.tr,
                                  enable: false,
                                  controller: TextEditingController(
                                    text: selectedDate != null
                                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                        : '',
                                  ),
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                              ),
                              SizedBox(height: 1.3.h),
                              onPress(
                                ontap: () async {
                                  selectedTime = await pickTime(context);
                                  if (selectedTime != null) {
                                    setState(() {});
                                  }
                                },
                                child: textFieldWithPrefixSuffuxIconAndHintText(
                                  'Select Time'.tr,
                                  enable: false,
                                  controller: TextEditingController(
                                    text: selectedTime != null
                                        ? selectedTime!.format(context)
                                        : '',
                                  ),
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                              ),
                              SizedBox(height: 1.3.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                'Poker Run Cost'.tr,
                                fillColor: Colors.white,
                                mainTxtColor: Colors.black,
                                controller: pokerRunCostController,
                                textInputType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                radius: 12,
                                bColor: Color(0xffEDF1F3),
                                hintColor: Color(0xff868686),
                                pColor: MyColors.primary,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Do you want participants to have the option of adding a Co-rider?",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff6C7278),
                              ),
                              Row(
                                children: [
                                  CustomCheckBox(
                                    value: eventModel.coRider ?? false,
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        eventModel.coRider = val;
                                      });
                                      if (eventModel.coRider ?? false) {
                                        scrollController.animateTo(
                                          scrollController
                                                  .position
                                                  .maxScrollExtent +
                                              100,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  text_widget(
                                    "Yes",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6C7278),
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomCheckBox(
                                    value: !(eventModel.coRider ?? false),
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        eventModel.coRider = !val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  text_widget(
                                    "No",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6C7278),
                                  ),
                                ],
                              ),
                              if (eventModel.coRider ?? false) ...[
                                SizedBox(height: 1.3.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "If Yes, what is the cost for the Co-rider? ",
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  controller: coRiderCostController,
                                  textInputType:
                                      TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                              ],
                              SizedBox(height: 1.3.h),
                              text_widget(
                                "Do you want participants to have the option of changing their card at each stop for a one time prepaid fee?",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff6C7278),
                              ),
                              Row(
                                children: [
                                  CustomCheckBox(
                                    value: eventModel.isAdditionalCard ?? false,
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        eventModel.isAdditionalCard = val;
                                      });
                                      if (eventModel.isAdditionalCard ??
                                          false) {
                                        scrollController.animateTo(
                                          scrollController
                                                  .position
                                                  .maxScrollExtent +
                                              100,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  text_widget(
                                    "Yes",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6C7278),
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomCheckBox(
                                    value:
                                        !(eventModel.isAdditionalCard ?? false),
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        eventModel.isAdditionalCard = !val;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 1.w),
                                  text_widget(
                                    "No",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6C7278),
                                  ),
                                ],
                              ),
                              if (eventModel.isAdditionalCard ?? false) ...[
                                SizedBox(height: 1.3.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "What is the cost of Additional Cards?",
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  controller: additionalCostController,
                                  textInputType:
                                      TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  radius: 12,
                                  bColor: Color(0xffEDF1F3),
                                  hintColor: Color(0xff868686),
                                  pColor: MyColors.primary,
                                ),
                              ],
                              SizedBox(height: 2.h),
                              customButon(
                                isIcon: false,
                                btnText: "Continue",
                                icon: "assets/icons/p1.png",
                                onTap: () {
                                  if (nameController.text.trim().isEmpty ||
                                      descriptionController.text
                                          .trim()
                                          .isEmpty ||
                                      pokerRunCostController.text
                                          .trim()
                                          .isEmpty ||
                                      selectedDate == null ||
                                      selectedTime == null) {
                                    toast(
                                      "Info",
                                      "Please fill all the required fields.",
                                    );
                                    return;
                                  }
                                  if (eventModel.coRider ?? false) {
                                    if (coRiderCostController.text
                                        .trim()
                                        .isEmpty) {
                                      toast(
                                        "Info",
                                        "Please fill Co-Rider cost.",
                                      );
                                      return;
                                    }
                                  }
                                  if (eventModel.isAdditionalCard ?? false) {
                                    if (additionalCostController.text
                                        .trim()
                                        .isEmpty) {
                                      // toast(
                                      //   "Info",
                                      //   "Please fill Additional Cards cost.",
                                      // );
                                      return;
                                    }
                                  }
                                  eventModel.pokerName = nameController.text;
                                  eventModel.description =
                                      descriptionController.text;
                                  eventModel.eventDate = selectedDate!;
                                  eventModel.eventTimezone = selectedTime!.hour;
                                  eventModel.joinFee = toDouble(
                                    pokerRunCostController.text,
                                  );
                                  eventModel.coRiderFee = toDouble(
                                    coRiderCostController.text,
                                  );
                                  eventModel.changeCardFee = toDouble(
                                    additionalCostController.text,
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // Get.to(PokerRoute(eventModel));
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
