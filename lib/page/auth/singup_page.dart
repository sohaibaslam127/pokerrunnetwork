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

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  bool shouldCheck = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (userNameController.text.isEmpty) {
      toast(context, "Username", "Username is required", type: 1);
    } else if (fullNameController.text.isEmpty) {
      toast(context, "Full name", "Full name is required", type: 1);
    } else if (emailController.text.isEmpty) {
      toast(context, "Email", "Email is required", type: 1);
    } else if (passwordController.text.isEmpty) {
      toast(context, "Password", "Password is required", type: 1);
    } else if (passwordController.text.length < 6) {
      toast(
        context,
        "Password",
        "Select a strong password is required",
        type: 1,
      );
    } else if (confirmPasswordController.text !=
        confirmPasswordController.text) {
      toast(context, "Confirm Password", "Passwords must match", type: 1);
    } else if (!shouldCheck) {
      toast(
        context,
        "Term and Conditions",
        "You must need to accept Term and Conditions",
        type: 1,
      );
    } else {
      bool roadUnique = await FirestoreServices.I.isRoadNameUnique(
        userNameController.text.trim().toLowerCase(),
      );
      if (!roadUnique) {
        toast(
          context,
          "Road name taken",
          "This Road Name/User Name is already in use. Suggestion like: ${userNameController.text}01",
        );
        return;
      }
      AuthServices.I
          .emailSignUp(emailController.text, passwordController.text)
          .then((result) async {
            if (result.isEmpty) {
              currentUser.email = emailController.text;
              currentUser.roadName = userNameController.text
                  .trim()
                  .toLowerCase();
              currentUser.name = fullNameController.text;
              currentUser.number = phoneController.text;
              bool isRegistered = await FirestoreServices.I.registerUser();
              if (isRegistered) {
                Get.offAll(() => const HomePage());
              } else {
                toast(
                  context,
                  "Register User",
                  "Failed to register user",
                  type: 1,
                );
              }
            } else {
              toast(context, "Error", result, type: 1);
            }
          });
    }
  }

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
                                  "Register",
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 2.5.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Username'.tr,
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
                              'Enter Full Name'.tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              controller: fullNameController,
                              radius: 12,
                              textInputType: TextInputType.text,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Enter Phone Number (Optional)'.tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              controller: phoneController,
                              radius: 12,
                              textInputType: TextInputType.phone,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              'Email Address'.tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              controller: emailController,
                              radius: 12,
                              textInputType: TextInputType.emailAddress,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Password".tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              controller: passwordController,
                              radius: 12,
                              textInputType: TextInputType.visiblePassword,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                            SizedBox(height: 1.3.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Confirm Password".tr,
                              fillColor: Colors.white,
                              mainTxtColor: Colors.black,
                              textInputAction: TextInputAction.done,
                              radius: 12,
                              textInputType: TextInputType.visiblePassword,
                              bColor: Color(0xffEDF1F3),
                              hintColor: Color(0xff868686),
                              controller: confirmPasswordController,
                              pColor: MyColors.primary,
                              isSuffix: true,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Spacer(),
                                CustomCheckBox(
                                  value: shouldCheck,
                                  shouldShowBorder: true,
                                  borderColor: MyColors.primary,
                                  checkedFillColor: MyColors.primary,
                                  borderRadius: 4,
                                  borderWidth: 1.5,
                                  checkBoxSize: 18,
                                  onChanged: (val) {
                                    setState(() {
                                      shouldCheck = val;
                                    });
                                  },
                                ),
                                SizedBox(width: .5.w),
                                RichText(
                                  text: TextSpan(
                                    text: 'I Accept ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launchMyUrl(
                                              'https://thepokerrunapp.com/contact-us%2Fprivacy-policy',
                                            );
                                          },
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MyColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            customButon(
                              isIcon: false,
                              btnText: "Sign Up",
                              icon: "assets/icons/p1.png",
                              onTap: signUp,
                            ),
                            SizedBox(height: 2.h),
                            Center(
                              child: onPress(
                                ontap: () {
                                  Get.back();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign In',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MyColors.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
