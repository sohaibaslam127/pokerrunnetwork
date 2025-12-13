import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/models/userModel.dart';
import 'package:url_launcher/url_launcher.dart';

void toast(String title, String message) {
  Get.snackbar(
    title.toUpperCase(),
    message,
    colorText: Colors.white,
    backgroundColor: MyColors.secondary,
  );
}

void launchMyUrl(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  } catch (e) {
    debugPrint("Error launching URL: $e");
  }
}

List<String> generateArray(String name, [bool subSearch = false]) {
  name = name.toLowerCase();
  List<String> list = [];
  for (int i = 0; i < name.length; i++) {
    list.add(name.substring(0, i + 1));
  }
  if (subSearch) {
    for (String test in name.split(' ')) {
      for (int i = 0; i < test.length; i++) {
        list.add(test.substring(0, i + 1));
      }
    }
  }
  return list;
}

Future<void> openStore(bool playStoreId, bool appStoreId) async {
  final String url = GetPlatform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=$playStoreId'
      : 'https://apps.apple.com/app/id$appStoreId';

  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch $url');
  }
}

UserModel currentUser = UserModel();
String countryCode = "US";
String appId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544~3347511713"
    : "ca-app-pub-3940256099942544~1458002511";

String adUnitId = Platform.isAndroid
    ? "ca-app-pub-3940256099942544/2247696110"
    : "ca-app-pub-3940256099942544/3986624511";

final mapApiKey = Platform.isAndroid
    ? "AIzaSyBe5djPy8Cpm6fZMl14cmjw4ZewHtKFPI0"
    : "AIzaSyCnUqH6cLCs3mjzRLLbPQYcPIoePD299Ps";

double serviceFee = 0.0;
double miles = 0.062137;
String helpLineNumber = "";
String helpLineEmail = "";
String website = "";
double coriderFee = -1.0; // -1.0 mean same as service fee

// Not on the admin panel, only set from remote config
String defaultSponsor = "";
bool enableAds = false;
String latestAppVersion = "";
bool needApproval = true;
bool autoFillCards = false;
