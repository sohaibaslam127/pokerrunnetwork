import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/page/home/poker_route.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePoker extends StatefulWidget {
  const CreatePoker({super.key});

  @override
  State<CreatePoker> createState() => _CreatePokerState();
}

class _CreatePokerState extends State<CreatePoker> {
  bool shouldCheck = false;
  DateTime? selectedDate;
  Future<DateTime?> pickDate(BuildContext context) async {
    const primaryColor = Color(0xFFF0C11D);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: "Select Date",
      confirmText: "Done",
      cancelText: "Cancel",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Buttons color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }

  TimeOfDay? selectedTime;
  Future<TimeOfDay?> pickTime(BuildContext context) async {
    const primaryColor = Color(0xFFF0C11D);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // Header color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
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
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),

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
                              mainTxtColor: Colors.black,
                              radius: 12,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Description".tr,

                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
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
                                  print("Selected Date: $selectedDate");
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
                                  print(
                                    "Selected Time: ${selectedTime!.format(context)}",
                                  );
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
                              radius: 12,

                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),

                              pColor: MyColors.primary,
                            ),

                            SizedBox(height: 2.h),
                            text_widget(
                              "Do you want participants to have the option of adding a co-rider?",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6C7278),
                            ),
                            Row(
                              children: [
                                CustomCheckBox(
                                  value: shouldCheck,
                                  shouldShowBorder: true,
                                  borderColor: Color(0xff6C7278),
                                  checkedFillColor: MyColors.primary,
                                  borderRadius: 4,
                                  borderWidth: 1.5,
                                  checkBoxSize: 16,
                                  onChanged: (val) {
                                    //do your stuff here
                                    setState(() {
                                      shouldCheck = val;
                                    });
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
                                  value: shouldCheck,
                                  shouldShowBorder: true,
                                  borderColor: Color(0xff6C7278),
                                  checkedFillColor: MyColors.primary,
                                  borderRadius: 4,
                                  borderWidth: 1.5,
                                  checkBoxSize: 16,

                                  onChanged: (val) {
                                    //do your stuff here
                                    setState(() {
                                      shouldCheck = val;
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
                            SizedBox(height: 2.h),
                            text_widget(
                              "Do you want participants to have the option of changing their card at each stop?",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6C7278),
                            ),
                            Row(
                              children: [
                                CustomCheckBox(
                                  value: shouldCheck,
                                  shouldShowBorder: true,
                                  borderColor: Color(0xff6C7278),
                                  checkedFillColor: MyColors.primary,
                                  borderRadius: 4,
                                  borderWidth: 1.5,
                                  checkBoxSize: 16,
                                  onChanged: (val) {
                                    //do your stuff here
                                    setState(() {
                                      shouldCheck = val;
                                    });
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
                                  value: shouldCheck,
                                  shouldShowBorder: true,
                                  borderColor: Color(0xff6C7278),
                                  checkedFillColor: MyColors.primary,
                                  borderRadius: 4,
                                  borderWidth: 1.5,
                                  checkBoxSize: 16,

                                  onChanged: (val) {
                                    //do your stuff here
                                    setState(() {
                                      shouldCheck = val;
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

                            SizedBox(height: 2.5.h),
                            customButon(
                              isIcon: false,
                              btnText: "Continue",
                              icon: "assets/icons/p1.png",
                              onTap: () {
                                Get.to(PokerRoute());
                                // Get.to(() =>  );
                              },
                            ),

                            SizedBox(height: 2.h),
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
      ],
    );
  }
}
