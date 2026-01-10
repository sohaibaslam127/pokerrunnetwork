import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/poker_view.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindPoker extends StatefulWidget {
  const FindPoker({super.key});

  @override
  State<FindPoker> createState() => _FindPokerState();
}

class _FindPokerState extends State<FindPoker> {
  Future<void> logout() async {
    showPopup(
      context,
      "Are You Sure, You Want To Logout?",
      PopupActionsButtons.cancel,
      PopupActionsButtons.logout,
      () {
        Get.back();
      },
      () async {
        Get.back();
        await AuthServices.I.logOut();
        Get.offAll(() => const LoginPage());
      },
    );
  }

  Future<void> deleteAccount() async {
    showPopup(
      context,
      "Are You Sure, You Want To Delete Your Account, You Will Not Be Able To Undo This Action?",
      PopupActionsButtons.deleteAccount,
      PopupActionsButtons.cancel,
      () async {
        Get.back();
        await FirestoreServices.I.deleteAccount();
        await AuthServices.I.logOut();
        Get.offAll(() => const LoginPage());
      },
      () {
        Get.back();
      },
    );
  }

  void editProfile() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void helpLine() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void termsAndConditions() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  void reportProblem() {
    launchMyUrl('https://thepokerrunapp.com/contact-us%2Fprivacy-policy');
  }

  TextEditingController searchPokerRun = TextEditingController();

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
          appBar: AppBar(
            backgroundColor: Colors.transparent.withValues(alpha: .2),
            leadingWidth: 8.w,
            leading: Padding(
              padding: EdgeInsets.only(bottom: 3.5),
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
              "Find A Poker Run",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  'Search by event name'.tr,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  mainTxtColor: Colors.black,
                  showPrefix: true,
                  controller: searchPokerRun,
                  onChange: (value) {
                    setState(() {});
                  },
                  prefixImage: "assets/icons/s1.png",
                  radius: 12,
                  textInputType: TextInputType.emailAddress,
                  bColor: Colors.white.withValues(alpha: 0.3),
                  hintColor: Color(0xff868686),
                  pColor: MyColors.primary,
                ),
                SizedBox(height: .5.h),
                Expanded(
                  child: PaginateFirestore(
                    key: searchPokerRun.text.isEmpty
                        ? Key("all_events")
                        : Key(searchPokerRun.text),
                    isLive: true,
                    onEmpty: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 45.h),
                        child: text_widget(
                          "No Event Found",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    separator: SizedBox(height: 1.h),
                    initialLoader: Padding(
                      padding: EdgeInsets.only(bottom: 45.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    itemBuilder: (BuildContext context, documentSnapshots, index) {
                      if (documentSnapshots[index].exists) {
                        EventModel event = EventModel.toModel(
                          documentSnapshots[index].data()
                              as Map<String, dynamic>,
                        );
                        if (!event.userIds
                            .map((e) => e)
                            .toList()
                            .contains(currentUser.id)) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: text_widget(
                                          event.pokerName,
                                          fontSize: 16.5.sp,
                                          maxline: 2,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      text_widget(
                                        DateFormat(
                                          'dd MMM, hh:mm a',
                                        ).format(event.eventDate),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  text_widget(
                                    event.description,
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: text_widget(
                                          '\$${event.joinFee.toStringAsFixed(2)}',
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      onPress(
                                        ontap: () async {
                                          GamePlayerModel coRider =
                                              await FirestoreServices.I
                                                  .isValidCorider(event.id);
                                          Get.to(
                                            PokerDetailsView(event, coRider),
                                          );
                                        },
                                        child: Container(
                                          width: 18.w,
                                          height: 3.h,
                                          decoration: BoxDecoration(
                                            color: Color(0xff5CAF5F),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: text_widget(
                                              "Join",
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return Container();
                    },
                    query: searchPokerRun.text.isEmpty
                        ? FirestoreServices.I.getEvents()
                        : FirestoreServices.I.searchEvents(searchPokerRun.text),
                    itemBuilderType: PaginateBuilderType.listView,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
