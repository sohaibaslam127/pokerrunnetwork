import 'dart:async';
import 'dart:io';
import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pokerrunnetwork/close_app.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/firebase_options.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/3rd_party/ad_service.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/services/locationsServices.dart';
import 'package:pokerrunnetwork/services/remortConfig.dart';
import 'package:pokerrunnetwork/services/stripeServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
    init().then((appRun) async {
      if (appRun) {
        await _checkForUpdate();
        Widget destination;
        if (currentUser.id.isEmpty) {
          destination = LoginPage();
        } else {
          destination = const HomePage();
        }
        Get.offAll(() => destination);
      }
    });
  }

  bool _isNewerVersion(String latest, String current) {
    List<int> parse(String v) {
      final parts = v.split('+');
      return parts[0].split('.').map((s) => int.tryParse(s) ?? 0).toList();
    }

    final l = parse(latest);
    final c = parse(current);
    final maxLength = l.length > c.length ? l.length : c.length;

    for (int i = 0; i < maxLength; i++) {
      final lVal = i < l.length ? l[i] : 0;
      final cVal = i < c.length ? c[i] : 0;
      if (lVal > cVal) return true;
      if (lVal < cVal) return false;
    }
    return false;
  }

  Future<void> _checkForUpdate() async {
    if (appVersionNetwork.isEmpty) return;
    final currentVersion = '$version';
    if (!_isNewerVersion(appVersionNetwork, currentVersion)) return;

    await Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6.h),
                padding: EdgeInsets.fromLTRB(6.w, 8.h, 6.w, 4.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.secondaryDark, MyColors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(18.sp),
                  border: Border.all(
                    color: MyColors.primary.withOpacity(0.50),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    text_widget(
                      "Update Required",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "A new version ($appVersionNetwork) of Poker Run Network is available. Please update to continue.",
                      fontSize: 14.5.sp,
                      color: Colors.white.withOpacity(0.85),
                      textAlign: TextAlign.center,
                      height: 1.3,
                    ),
                    SizedBox(height: 3.5.h),
                    customButon(
                      btnText: "Update Now",
                      onTap: () async {
                        final uri = Uri.parse(
                          Platform.isAndroid
                              ? 'https://play.google.com/store/apps/details?id=com.techbolic.pokernetwork'
                              : 'https://apps.apple.com/app/poker-run-network/id6478165987',
                        );
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primary,
                        MyColors.primary.withOpacity(0.30),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 5.5.h,
                    backgroundColor: MyColors.black,
                    child: Icon(
                      RemixIcons.download_cloud_2_line,
                      size: 28.sp,
                      color: MyColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    if (isConnected) {
      logger.i('Device is connected to the internet');
    } else {
      Get.offAll(
        CloseApp(
          "No Internet Connection!",
          "Poker Run Network requires active internet connection to function. Please enable internet and restart the app.",
          onRetry: () {
            Get.offAll(() => const SplashScreen());
          },
        ),
      );
      return false;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await RemoteConfigService().init();
    _initializeAds();
    await FirestoreServices.I.init();
    await StripeServices.I.init();
    await AuthServices.I.checkUser();
    await LocationServices.I.getUserLocation();
    return true;
  }

  Future<void> _initializeAds() async {
    AdHelper.setupAdLogging();
    AdIdRegistry.initialize(
      ios: {AdType.native: adUnitId},
      android: {AdType.native: adUnitId},
    );
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
            child: text_widget(
              "Version   $version+$buildNumber".toUpperCase(),
              color: Colors.white38,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
