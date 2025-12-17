import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/firebase_options.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/services/locationsServices.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "", buildNumber = "";
  @override
  void initState() {
    super.initState();
    init().then((_) {
      Timer(const Duration(seconds: 2), () async {
        if (currentUser.id == "") {
          Get.offAll(() => const LoginPage());
        } else {
          Get.offAll(() => const HomePage());
        }
      });
    });
  }

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Future.wait([
      FirestoreServices.I.init(),
      LocationServices.I.getUserLocation(),
    ]);
    await AuthServices.I.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background/splashscreen.jpg',
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "Version $version+$buildNumber".toUpperCase(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.25),
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.8,
                wordSpacing: 5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
