import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      // check if user is available
     
      // ✅ Fully registered user → go to UserDrawer
      Get.offAll(() => const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/sp.jpg',
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
          // 'assets/images/img3.jpg'
        ),
      ],
    );
  }
}
