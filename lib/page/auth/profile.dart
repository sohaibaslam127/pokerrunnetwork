import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/background/lightbackground.jpg",
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
                    child: Image.asset("assets/logo/logo.png", height: 10.h),
                  ),
                  SizedBox(height: 3.h),

                  Center(
                    child: Container(
                      width: 88.w,
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
                                text_widget(
                                  "Profile",
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'sohaibaslam@gmail.com'.tr,
                              fillColor: Color(0xffF4F4F4),
                            
                              mainTxtColor: Colors.black,
                              radius: 12,
                              textInputType: TextInputType.text,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '@username'.tr,
                              fillColor: Color(0xffF4F4F4),
                              mainTxtColor: Colors.black,
                         
                              radius: 12,
                              textInputType: TextInputType.text,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Sohaib Aslam'.tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                             
                              radius: 12,
                              textInputType: TextInputType.phone,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '030823780893'.tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                           
                              radius: 12,
                              textInputType: TextInputType.emailAddress,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                           
                            SizedBox(height: 2.h),
                            customButon(
                              isIcon: false,
                              btnText: "Save Changes",
                              icon: "assets/icons/p1.png",
                             
                            ),
                            SizedBox(height: 2.h),
                                 SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
