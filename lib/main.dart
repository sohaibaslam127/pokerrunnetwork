
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/page/auth/splash_screen.dart';
import 'package:pokerrunnetwork/page/home/co_manager_menu.dart';
import 'package:pokerrunnetwork/page/home/affilate_menu.dart';
import 'package:pokerrunnetwork/page/home/co_manager.dart';
import 'package:pokerrunnetwork/page/home/manager_pokerRun_1.dart';
import 'package:pokerrunnetwork/page/home/manager_poker_2.dart';
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
  // Initialize once, with the generated options
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
   
          theme: ThemeData(
        
    fontFamily: "Calibri",
  
          ),
          defaultTransition: Transition.noTransition,
          home: SplashScreen(),
        );
      },
    );
  }
}
