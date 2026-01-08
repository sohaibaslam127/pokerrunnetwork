import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/complete_poker_view.dart';
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

class CompletedPokr extends StatefulWidget {
  const CompletedPokr({super.key});

  @override
  State<CompletedPokr> createState() => _CompletedPokrState();
}

class _CompletedPokrState extends State<CompletedPokr> {
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
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 14.w,
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
              "Completed Poker Run",
              letterSpacing: 1.5,
              fontSize: 20.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                  SizedBox(height: 4.h),
                  onPress(
                    ontap: (){
                      Get.to(CompletePokerView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                text_widget("Johnson",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                    Spacer(),
                                    
                              ],
                            ),
                            SizedBox(height: 1.h),
                             Row(
                               children: [
                               text_widget("31 DEC 2025, 02:02 PM",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.6)),
                                        Spacer(),
                                       Icon(Remix.arrow_right_s_line, color: Colors.white, size: 4.h,),
                               ],
                             ),
                               SizedBox(height: 1.h),
                             Row(
                               children: [
                                 text_widget("Winner: ",
                                        fontSize: 15.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                           text_widget("Sohaib Khan",
                                        fontSize: 15.5.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                        Spacer(),
                                         text_widget("Rank: ",
                                        fontSize: 15.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                           text_widget("Straight",
                                        fontSize: 15.5.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                               ],
                             ),
                          
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Expanded(
                                  child: onPress(
                                    ontap: (){
                                      showDialog(context: context, builder: (context) => const DeletePop1());
                                    },
                                    child: Container(
                                          width: 22.w,
                                          height: 4.8.h,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFF7A7A),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child:  text_widget("Delete",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                          ),
                                        ),
                                  ),
                                ),
                             
                              ],
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
      ],
    );
  }
}
