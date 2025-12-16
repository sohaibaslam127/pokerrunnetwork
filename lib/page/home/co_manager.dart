import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoManagerPage extends StatefulWidget {
  EventModel eventModel;
  CoManagerPage(this.eventModel, {super.key});

  @override
  State<CoManagerPage> createState() => _CoManagerPageState();
}

class _CoManagerPageState extends State<CoManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/icons/bbg.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.transparent.withValues(alpha: 0.08),
            surfaceTintColor: Colors.transparent.withValues(alpha: 0.08),
            backgroundColor: Colors.transparent.withValues(alpha: 0.08),

            elevation: 0,
            leadingWidth: 14.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: onPress(
                ontap: () {
                  Get.back();
                },
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 24.sp,
                  color: Colors.white.withValues(alpha: 0.80),
                ),
              ),
            ),
            title: text_widget(
              "Co-Manager List",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
            actions: [
              onPress(
                ontap: () {
                  addcoManagerPopup(context);
                },
                child: Image.asset("assets/icons/addc.png", height: 5.5.h),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: List.generate(widget.eventModel.coManagers.length, (
                index,
              ) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.2.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      border: Border.all(
                        color: const Color(0xffFFFFFF).withValues(alpha: 0.30),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: text_widget(
                        widget.eventModel.coManagerNames[index].capitalize!,
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                      subtitle: text_widget(
                        widget.eventModel.coManagers[index].toLowerCase(),
                        fontSize: 14.7.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.60),
                      ),
                      trailing: onPress(
                        ontap: () {
                          showPopup(
                            context,
                            "Are You Sure You Want To Remove That Co-Manager?",
                            ButtonActions.noButton,
                            ButtonActions.removeButton,
                            () async {
                              Get.back();
                            },
                            () {
                              Get.back();
                              widget.eventModel.coManagers.remove(
                                widget.eventModel.coManagers[index],
                              );
                              widget.eventModel.coManagerNames.remove(
                                widget.eventModel.coManagerNames[index],
                              );
                              setState(() {});
                              FirestoreServices.I.setEvent(
                                context,
                                widget.eventModel,
                                null,
                                false,
                              );
                            },
                          );
                        },
                        child: Image.asset("assets/icons/rem.png", height: 3.h),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void addcoManagerPopup(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true, // Close on tap outside
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),
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
                      Text(
                        "Add New Co-Manager",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter the name of the co-manager".tr,
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    textInputType: TextInputType.text,
                    radius: 12,
                    controller: nameController,
                    bColor: Color(0xffEDF1F3),
                    hintColor: Color(0xff868686),
                    pColor: MyColors.primary,
                  ),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter the email of the co-manager".tr,
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    textInputType: TextInputType.emailAddress,
                    radius: 12,
                    controller: emailController,
                    bColor: Color(0xffEDF1F3),
                    hintColor: Color(0xff868686),
                    pColor: MyColors.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (nameController.text.isEmpty) {
                              toast(
                                context,
                                "Invalid name",
                                "Please enter the name of the co-manager",
                                type: 2,
                              );
                              return;
                            }
                            if (!emailController.text.isEmail) {
                              toast(
                                context,
                                "Invalid email",
                                "Please enter a valid email",
                                type: 2,
                              );
                              return;
                            }
                            String email = emailController.text
                                .toLowerCase()
                                .trim();
                            if (widget.eventModel.coManagers.contains(email)) {
                              toast(
                                context,
                                "Duplicate email",
                                "This email is already added as a co-manager",
                                type: 2,
                              );
                              return;
                            }
                            widget.eventModel.coManagers.add(email);
                            widget.eventModel.coManagerNames.add(
                              nameController.text,
                            );
                            setState(() {});
                            FirestoreServices.I.setEvent(
                              context,
                              widget.eventModel,
                              null,
                              false,
                            );
                          },
                          child: Image.asset(
                            "assets/icons/addc1.png",
                            height: 10.h,
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
      },
    );
  }
}
