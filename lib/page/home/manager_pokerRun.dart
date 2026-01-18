import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/page/home/partner_list.dart';
import 'package:pokerrunnetwork/page/home/co_manager.dart';
import 'package:pokerrunnetwork/page/home/create_poker.dart';
import 'package:pokerrunnetwork/page/home/progress_poker.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManagerPokerRun extends StatefulWidget {
  final EventModel eventModel;
  const ManagerPokerRun(this.eventModel, {super.key});

  @override
  State<ManagerPokerRun> createState() => _ManagerPokerRun1State();
}

class _ManagerPokerRun1State extends State<ManagerPokerRun> {
  bool isCoManager = false;
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isCoManager = widget.eventModel.coManagers.contains(
        currentUser.email.toLowerCase(),
      );
      isCompleted = widget.eventModel.status == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff000435),
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
              "Back",
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
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.5.h),
                    Center(
                      child: Image.asset("assets/logo/logo.png", height: 22.h),
                    ),
                    SizedBox(height: 2.h),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: text_widget(
                          "Manage ${widget.eventModel.pokerName.capitalize} Poker Run",
                          textAlign: TextAlign.center,
                          fontSize: 22.sp,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 1.w,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        if (!isCompleted)
                          onPress(
                            ontap: () {
                              Get.to(CreatePoker(widget.eventModel));
                            },
                            child: Image.asset(
                              MenuActionButtons.editPokerrun,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (!isCompleted)
                          onPress(
                            ontap: () {
                              Get.to(
                                PartnerList(
                                  type: 0,
                                  eventModel: widget.eventModel,
                                ),
                              );
                            },
                            child: Image.asset(
                              MenuActionButtons.authorizeParticipants,
                              fit: BoxFit.contain,
                            ),
                          ),
                        onPress(
                          ontap: () {
                            Get.to(
                              PartnerList(
                                type: 1,
                                eventModel: widget.eventModel,
                              ),
                            );
                          },
                          child: Image.asset(
                            MenuActionButtons.progressPokerrun,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (!isCompleted)
                          onPress(
                            ontap: () {
                              showPopup(
                                context,
                                'Are you sure your Poker Run is completed and you are ready to publish the results?',
                                PopupActionsButtons.complete,
                                PopupActionsButtons.no,
                                () async {
                                  Get.back();
                                  EasyLoading.show();
                                  if (autoFillCards) {
                                    await FirestoreServices.I.autoFillCards(
                                      widget.eventModel.id,
                                    );
                                    EasyLoading.dismiss();
                                  }
                                  if (widget.eventModel.userIds.isNotEmpty) {
                                    widget.eventModel.eventWinner =
                                        await FirestoreServices.I.getGameWinner(
                                          widget.eventModel.id,
                                        );
                                  }
                                  widget.eventModel.status = 2;
                                  isCompleted = true;
                                  await FirestoreServices.I.setEvent(
                                    context,
                                    widget.eventModel,
                                    null,
                                    false,
                                  );
                                  setState(() {});
                                  EasyLoading.dismiss();
                                },
                                () async {
                                  Get.back();
                                },
                              );
                            },
                            child: Image.asset(
                              MenuActionButtons.finishPokerrun,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (!isCoManager)
                          onPress(
                            ontap: () {
                              showPopup(
                                context,
                                "Are you sure you want to Copy an Existing Poker Run",
                                PopupActionsButtons.cancel,
                                PopupActionsButtons.copy,
                                () {
                                  Get.back();
                                },
                                () {
                                  Get.back();
                                  widget.eventModel.id = "";
                                  widget.eventModel.status = 1;
                                  widget.eventModel.eventWinner = null;
                                  widget.eventModel.userIds = [];
                                  Get.to(CreatePoker(widget.eventModel));
                                },
                              );
                            },
                            child: Image.asset(
                              MenuActionButtons.copyExistingPokerrun,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (isCompleted && !isCoManager)
                          onPress(
                            ontap: () {
                              showPopup(
                                context,
                                "Are You Sure You Want To Delete That Poker Run?",
                                PopupActionsButtons.deleteEvent,
                                PopupActionsButtons.no,
                                () async {
                                  Get.back();
                                  EasyLoading.show();
                                  await FirestoreServices.I.deleteEvent(
                                    widget.eventModel.id,
                                  );
                                  EasyLoading.dismiss();
                                  Get.back();
                                },
                                () {
                                  Get.back();
                                },
                              );
                            },
                            child: Image.asset(
                              MenuActionButtons.deletePokerrun,
                              fit: BoxFit.fill,
                            ),
                          ),
                        if (!isCoManager)
                          onPress(
                            ontap: () {
                              Get.to(CoManagerPage(widget.eventModel));
                            },
                            child: Image.asset(
                              MenuActionButtons.authorizedComanager,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (isCoManager)
                          onPress(
                            ontap: () async {
                              showPopup(
                                context,
                                "Are You Sure You Want To Remove Yourself As Co-Manager?",
                                PopupActionsButtons.remove,
                                PopupActionsButtons.no,
                                () async {
                                  Get.back();
                                  int index = widget.eventModel.coManagers
                                      .indexOf(currentUser.email.toLowerCase());
                                  widget.eventModel.coManagers.removeAt(index);
                                  widget.eventModel.coManagerNames.removeAt(
                                    index,
                                  );
                                  await FirestoreServices.I.setEvent(
                                    context,
                                    widget.eventModel,
                                    null,
                                    false,
                                  );
                                  Get.back();
                                },
                                () {
                                  Get.back();
                                },
                              );
                            },
                            child: Image.asset(
                              MenuActionButtons.removeYourself,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
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
