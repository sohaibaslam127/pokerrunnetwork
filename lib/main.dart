import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/page/auth/profile.dart';
import 'package:pokerrunnetwork/page/auth/singup_page.dart';
import 'package:pokerrunnetwork/page/auth/splash_screen.dart';
import 'package:pokerrunnetwork/page/home/active_poker_run.dart';
import 'package:pokerrunnetwork/page/home/completed_pokr.dart';
import 'package:pokerrunnetwork/page/home/game_view.dart';
import 'package:pokerrunnetwork/page/home/home_page1.dart';
import 'package:pokerrunnetwork/page/home/schedule_poker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (_, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Calibri"),
          defaultTransition: Transition.noTransition,
          home: HomePage1(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

// Heysarge@rocketmail.com
// Calcutta1313$
