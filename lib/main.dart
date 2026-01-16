import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/page/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (_, orientation, screenType) {
        return GetMaterialApp(
          // debugShowCheckedModeBanner: false,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Calibri"),
          defaultTransition: Transition.noTransition,
          // defaultTransition: Transition.noTransition,
          home: SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

// Heysarge@rocketmail.com
// Calcutta1313$