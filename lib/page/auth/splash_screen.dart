import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pokerrunnetwork/close_app.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/firebase_options.dart';
import 'package:pokerrunnetwork/page/auth/login_page.dart';
import 'package:pokerrunnetwork/page/home/home_page.dart';
import 'package:pokerrunnetwork/services/authServices.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/services/locationsServices.dart';
import 'package:pokerrunnetwork/services/remortConfig.dart';
import 'package:pokerrunnetwork/services/stripeServices.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
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

  Future<void> _initializeAds() async {
    AdHelper.setupAdLogging();
    AdIdRegistry.initialize(
      ios: {AdType.native: adUnitId},
      android: {AdType.native: adUnitId},
    );
  }

  /// Returns true if [latest] is a newer version than [current].
  /// Both strings must be in "X.Y.Z+build" format.
  bool _isNewerVersion(String latest, String current) {
    List<int> parse(String v) {
      final parts = v.split('+');
      final nums = parts[0].split('.').map((s) => int.tryParse(s) ?? 0).toList();
      nums.add(parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0);
      return nums;
    }

    final l = parse(latest);
    final c = parse(current);
    for (int i = 0; i < l.length && i < c.length; i++) {
      if (l[i] > c[i]) return true;
      if (l[i] < c[i]) return false;
    }
    return false;
  }

  Future<void> _checkForUpdate() async {
    if (latestAppVersion.isEmpty) return;

    final currentVersion = '$version+$buildNumber';
    if (!_isNewerVersion(latestAppVersion, currentVersion)) return;

    await Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                text_widget(
                  "Update Required",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                text_widget(
                  "A new version ($latestAppVersion) of Poker Run Player is available. Please update to continue.",
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final uri = Uri.parse(
                        Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=com.pokerrunplayer'
                            : 'https://apps.apple.com/app/poker-run-player/id6478165986',
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: text_widget(
                      "Update Now",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    if (isConnected) {
      log('Device is connected to the internet');
    } else {
      Get.offAll(
        CloseApp(
          "No Internet Connection!",
          "Poker Run Player requires active internet connection to function. Please enable internet and restart the app.",
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
    await AuthServices.I.checkUser();
    LocationServices.I.getUserLocation();
    StripeServices.I.init();
    return true;
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
