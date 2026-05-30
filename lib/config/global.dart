import 'dart:io';
import 'package:logger/logger.dart';
import 'package:pokerrunnetwork/models/userModel.dart';

import 'package:flutter/foundation.dart';

Logger logger = Logger();
UserModel currentUser = UserModel();
String countryCode = "US";
String appId = Platform.isAndroid
    ? "ca-app-pub-2555335650225733~9455106236"
    : "ca-app-pub-2555335650225733~8257574631";

String adUnitId = kDebugMode
    ? (Platform.isAndroid
          ? "ca-app-pub-3940256099942544/2247696110"
          : "ca-app-pub-3940256099942544/3986624511")
    : (Platform.isAndroid
          ? "ca-app-pub-2555335650225733/4266111318"
          : "ca-app-pub-2555335650225733/6860485065");

final mapApiKey = Platform.isAndroid
    ? "AIzaSyBe5djPy8Cpm6fZMl14cmjw4ZewHtKFPI0"
    : "AIzaSyCnUqH6cLCs3mjzRLLbPQYcPIoePD299Ps";

String helpLineNumber = "";
String helpLineEmail = "";
String website = "";

bool enableAds = false;
String appVersionNetwork = "";
bool needApproval = true;
bool autoFillCards = false;

List<String> pokerCards = [
  "assets/images/diamond/jack.png",
  "assets/images/diamond/ace.png",
  "assets/images/diamond/2.png",
  "assets/images/diamond/3.png",
  "assets/images/diamond/4.png",
  "assets/images/diamond/5.png",
  "assets/images/diamond/6.png",
  "assets/images/diamond/7.png",
  "assets/images/diamond/8.png",
  "assets/images/diamond/9.png",
  "assets/images/diamond/10.png",
  "assets/images/diamond/king.png",
  "assets/images/diamond/queen.png",

  "assets/images/spades/jack.png",
  "assets/images/spades/ace.png",
  "assets/images/spades/2.png",
  "assets/images/spades/3.png",
  "assets/images/spades/4.png",
  "assets/images/spades/5.png",
  "assets/images/spades/6.png",
  "assets/images/spades/7.png",
  "assets/images/spades/8.png",
  "assets/images/spades/9.png",
  "assets/images/spades/10.png",
  "assets/images/spades/king.png",
  "assets/images/spades/queen.png",

  "assets/images/club/jack.png",
  "assets/images/club/ace.png",
  "assets/images/club/2.png",
  "assets/images/club/3.png",
  "assets/images/club/4.png",
  "assets/images/club/5.png",
  "assets/images/club/6.png",
  "assets/images/club/7.png",
  "assets/images/club/8.png",
  "assets/images/club/9.png",
  "assets/images/club/10.png",
  "assets/images/club/king.png",
  "assets/images/club/queen.png",

  "assets/images/heart/jack.png",
  "assets/images/heart/ace.png",
  "assets/images/heart/2.png",
  "assets/images/heart/3.png",
  "assets/images/heart/4.png",
  "assets/images/heart/5.png",
  "assets/images/heart/6.png",
  "assets/images/heart/7.png",
  "assets/images/heart/8.png",
  "assets/images/heart/9.png",
  "assets/images/heart/10.png",
  "assets/images/heart/king.png",
  "assets/images/heart/queen.png",
];
