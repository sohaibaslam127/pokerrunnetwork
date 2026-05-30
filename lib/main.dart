import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/page/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  _configureEasyLoading();
  runApp(const MyApp());
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 42
    ..radius = 16
    ..backgroundColor = const Color(0xFF1E428A)
    ..indicatorColor = const Color(0xffF0C11D)
    ..textColor = const Color(0xffF0C11D)
    ..progressColor = const Color(0xffF0C11D)
    ..maskType = EasyLoadingMaskType.black
    ..maskColor = Colors.black.withValues(alpha: 0.55)
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
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
          home: SplashScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

// different location starting, nearby stop will be stop 1
// => when user get to any hole and get the card then it will be his first stop,
// then move to the next one and continue the game
