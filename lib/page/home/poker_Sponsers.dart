import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PokerSponsers extends StatefulWidget {
  const PokerSponsers({super.key});

  @override
  State<PokerSponsers> createState() => _PokerSponsersState();
}

class _PokerSponsersState extends State<PokerSponsers> {
  bool shouldCheck = false;
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
                      width: 92.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/icons/back.png",height: 4.5.h,),
                                SizedBox(width: 2.w),
                                text_widget("Sponsors",
                                
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                ),
                               
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                     ListView.builder(
  itemCount: 5,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    int number = index + 1;

 String suffix;
    if (number == 1) suffix = "st";
    else if (number == 2) suffix = "nd";
    else if (number == 3) suffix = "rd";
    else suffix = "th";
    // Convert number → First, Second, Third, Fourth, Fifth
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
        text_widget(
          "$number$suffix Sponsor",
          color: Color(0xff6C7278),
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 0.8.h),

        // First Text Field (Dynamic)
        textFieldWithPrefixSuffuxIconAndHintText(
          "Name of $word Sponsor",
          fillColor: Colors.white,
          mainTxtColor: Colors.black,
          radius: 12,
          padd: 16,
          bColor: Color(0xffEDF1F3),
          hintColor: Color(0xff868686),
          pColor: MyColors.primary,
        ),
        SizedBox(height: 1.2.h),

        // Second Text Field (Static)
        textFieldWithPrefixSuffuxIconAndHintText(
          "WWW.sponsorwebsite.com",
          fillColor: Colors.white,
          mainTxtColor: Colors.black,
          radius: 12,
          padd: 16,
          bColor: Color(0xffEDF1F3),
          hintColor: Color(0xff868686),
          pColor: MyColors.primary,
        ),

        SizedBox(height: 2.h),
      ],
    );
  },
),


                            SizedBox(height: 2.5.h),
                           customButon(
                              isIcon: false,
                              btnText: "Continue",
                              icon: "assets/icons/p1.png",
                              onTap: (){
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
