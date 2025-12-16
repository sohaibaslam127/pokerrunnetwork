import 'dart:io';
import 'package:pokerrunnetwork/models/userModel.dart';

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
