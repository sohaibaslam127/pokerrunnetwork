import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide SnackPosition;
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/poker_route.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePoker extends StatefulWidget {
  EventModel eventModel;
  CreatePoker(this.eventModel, {super.key});

  @override
  State<CreatePoker> createState() => _CreatePokerState();
}

class _CreatePokerState extends State<CreatePoker> {
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pokerRunCostController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController coRiderCostController = TextEditingController();
  TextEditingController additionalCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.eventModel.pokerName.trim().isNotEmpty) {
      nameController.text = widget.eventModel.pokerName;
      descriptionController.text = widget.eventModel.description;
      pokerRunCostController.text = widget.eventModel.joinFee.toString();
      coRiderCostController.text = widget.eventModel.coRiderFee.toString();
      additionalCostController.text = widget.eventModel.changeCardFee
          .toString();
      selectedDate = widget.eventModel.eventDate;
      selectedTime = TimeOfDay.fromDateTime(widget.eventModel.eventDate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    selectedDate = null;
    selectedTime = null;
    nameController.dispose();
    descriptionController.dispose();
    pokerRunCostController.dispose();
    coRiderCostController.dispose();
    additionalCostController.dispose();
  }

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
                                    widget.eventModel.id == ""
                                        ? "Create a new Poker Run"
                                        : "Edit Poker Run",
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
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 2),
                                ],
                                mainTxtColor: Colors.black,
                                controller: pokerRunCostController,
                                textInputType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                radius: 12,
                                prefixIcon: Icons.attach_money,
                                showPrefix: true,
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
                                    value: widget.eventModel.coRider ?? false,
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.eventModel.coRider = val;
                                      });
                                      if (widget.eventModel.coRider ?? false) {
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
                                        !(widget.eventModel.coRider ?? false),
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.eventModel.coRider = !val;
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
                              if (widget.eventModel.coRider ?? false) ...[
                                SizedBox(height: 1.3.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "If Yes, what is the cost for the Co-rider? ",
                                  fillColor: Colors.white,
                                  mainTxtColor: Colors.black,
                                  inputFormatters: [
                                    DecimalTextInputFormatter(decimalRange: 2),
                                  ],
                                  prefixIcon: Icons.attach_money,
                                  showPrefix: true,
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
                                    value:
                                        widget.eventModel.isAdditionalCard ??
                                        false,
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.eventModel.isAdditionalCard =
                                            val;
                                      });
                                      if (widget.eventModel.isAdditionalCard ??
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
                                        !(widget.eventModel.isAdditionalCard ??
                                            false),
                                    shouldShowBorder: true,
                                    borderColor: Color(0xff6C7278),
                                    checkedFillColor: MyColors.primary,
                                    borderRadius: 4,
                                    borderWidth: 1.5,
                                    checkBoxSize: 16,
                                    onChanged: (val) {
                                      setState(() {
                                        widget.eventModel.isAdditionalCard =
                                            !val;
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
                              if (widget.eventModel.isAdditionalCard ??
                                  false) ...[
                                SizedBox(height: 1.3.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "What is the cost of Additional Cards?",
                                  fillColor: Colors.white,
                                  prefixIcon: Icons.attach_money,
                                  inputFormatters: [
                                    DecimalTextInputFormatter(decimalRange: 2),
                                  ],
                                  showPrefix: true,
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
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                                      context,
                                      "Info",
                                      "Please fill all the required fields.",
                                    );
                                    return;
                                  }
                                  if (widget.eventModel.coRider ?? false) {
                                    if (coRiderCostController.text
                                        .trim()
                                        .isEmpty) {
                                      toast(
                                        context,
                                        "Co-Rider Cost",
                                        "Please fill Co-Rider cost.",
                                      );
                                      return;
                                    }
                                  }
                                  if (widget.eventModel.isAdditionalCard ??
                                      false) {
                                    if (additionalCostController.text
                                        .trim()
                                        .isEmpty) {
                                      toast(
                                        context,
                                        "Additional Cards Cost",
                                        "Please fill Additional Cards cost.",
                                      );
                                      return;
                                    }
                                  }
                                  widget.eventModel.pokerName =
                                      nameController.text;
                                  widget.eventModel.description =
                                      descriptionController.text;

                                  widget.eventModel.eventDate = DateTime(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                    selectedDate!.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                    0,
                                  );

                                  widget.eventModel.joinFee = toDouble(
                                    pokerRunCostController.text,
                                  );
                                  widget.eventModel.coRiderFee = toDouble(
                                    coRiderCostController.text,
                                  );
                                  widget.eventModel.changeCardFee = toDouble(
                                    additionalCostController.text,
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Get.to(PokerRoute(widget.eventModel));
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
