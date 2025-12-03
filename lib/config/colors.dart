import 'package:flutter/material.dart';




class MyColors {
  static Color white = Colors.white;
  static Color  primary = Color(0xffF0C11D);
  static Color primary1 = Color(0xff4D81E7);
  static Color primary2 = Color(0XFF6eaf25);

  static Color black = Color(0xff3C3C3C);
  static Color cyan = Color(0xff6CE5E7);
  static Color background = Color(0xffF9F9F9);
  static Color grey = Color(0xff262626);
  static Color txtclr1 = Color(0xffC65200);
  static Color txtclr2 = Color(0xff929292);
  static Color navColor = Color(0xffFA9A55).withOpacity(0.15);
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
int userType = 1;
String appLanguage = 'en';



// UserModel currentUser = UserModel();
// // MiniUserModel currentMiniUser = MiniUserModel();
// String kGoogleApiKey = GetPlatform.isAndroid
//     ? "AIzaSyCYDi_pDXcK5MwffAeTqIWZi1RiOK_47d4"
//     : "AIzaSyCtEDCykUDeCa7QkT-LK63xQ7msSXNZoq0";
