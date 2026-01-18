import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_field.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userNameController.text = currentUser.roadName;
    emailController.text = currentUser.email;
    nameController.text = currentUser.name;
    numberController.text = currentUser.number;
  }

  Future<void> updateUser() async {
    if (userNameController.text.isEmpty) {
      toast(context, "Username", "Unique Username is Required");
      return;
    }
    bool roadUnique = true;
    if (currentUser.roadName.toLowerCase() !=
        userNameController.text.trim().toLowerCase()) {
      roadUnique = await FirestoreServices.I.isRoadNameUnique(
        userNameController.text.trim().toLowerCase(),
      );
    }
    if (!roadUnique) {
      toast(
        context,
        "Road name taken",
        "This Road Name/User Name is already in use. Suggestion like: ${userNameController.text}01",
        type: 1,
      );
      return;
    }
    if (nameController.text.isEmpty) {
      toast(context, "Name", "Name is Required");
      return;
    }
    if (numberController.text.isEmpty) {
      toast(context, "Number", "Number is Required");
      return;
    }
    currentUser.roadName = userNameController.text;
    currentUser.name = nameController.text;
    currentUser.number = numberController.text;
    await FirestoreServices.I.updateUser();
    toast(context, "Profile", "Profile updated successfully", type: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
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
            resizeToAvoidBottomInset: true,
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
                "Profile".capitalize!,
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
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  Center(
                    child: Image.asset("assets/logo/logo.png", height: 18.h),
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
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                text_widget(
                                  "Edit Profile",
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'sohaibaslam@gmail.com'.tr,
                              controller: emailController,
                              fillColor: Color(0xffF4F4F4),
                              mainTxtColor: Colors.black,
                              radius: 12,
                              enable: false,
                              textInputType: TextInputType.text,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '@username'.tr,
                              fillColor: Colors.white,
                              controller: userNameController,
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
                              controller: nameController,
                              mainTxtColor: Colors.black,
                              radius: 12,
                              textInputType: TextInputType.name,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              '+91 3126560302'.tr,
                              fillColor: Colors.white,
                              controller: numberController,
                              mainTxtColor: Colors.black,
                              textInputAction: TextInputAction.done,
                              radius: 12,
                              textInputType: TextInputType.phone,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            SizedBox(height: 2.h),
                            customButon(
                              onTap: updateUser,
                              isIcon: false,
                              btnText: "Save Changes",
                              icon: "assets/icons/p1.png",
                            ),
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
        ],
      ),
    );
  }
}
