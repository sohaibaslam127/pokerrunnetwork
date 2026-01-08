import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snackify/enums/snack_enums.dart';
import 'package:snackify/snackify.dart';
import 'package:url_launcher/url_launcher.dart';

void toast(BuildContext context, String title, String message, {int type = 3}) {
  // success, 0
  // error, 1
  final topInset = MediaQuery.of(context).padding.top;
  Snackify.show(
    context: context,
    type: SnackType.values[type],
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    offset: Offset(3.w, topInset > 44 ? 3.h : 0),
    subtitle: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 16.sp),
    ),
    duration: const Duration(seconds: 2),
    backgroundGradient: LinearGradient(
      colors: type == 0
          ? [Colors.green.shade600, Colors.green.shade300]
          : type == 1
          ? [Colors.red.shade600, Colors.red.shade300]
          : type == 2
          ? [Colors.yellow.shade900, Colors.yellow.shade800]
          : [MyColors.secondaryDark, MyColors.secondary],
    ),
    position: SnackPosition.top,
  );
}

// Future<LocationResult> showPlacePicker(BuildContext context) async {
//   LocationResult? result = await Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (_) => Theme(
//         data: ThemeData(
//           appBarTheme: AppBarTheme(backgroundColor: MyColors.secondaryDark),
//         ),
//         child: PlacePicker(
//           mapApiKey,
//           displayLocation: LatLng(
//             currentUser.location.latitude,
//             currentUser.location.longitude,
//           ),
//         ),
//       ),
//     ),
//   );
//   return result ?? LocationResult();
// }

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

Future<DateTime?> pickDate(BuildContext context) async {
  final primaryColor = MyColors.secondary;
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    helpText: "Select Date",
    confirmText: "Done",
    cancelText: "Cancel",
    builder: (_, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double p = 0.017453292519943295;
  final c = cos;
  final a =
      0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  double km = 12742 * asin(sqrt(a));
  double miles = km * 0.621371;
  return miles;
}

Future<TimeOfDay?> pickTime(BuildContext context) async {
  final primaryColor = MyColors.secondary;
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (_, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

double toDouble<T>(T? input, {int precision = 1}) {
  double value = 0.0;
  if (input == null || input.toString().trim().isEmpty) {
    return value;
  }

  if (input is int) {
    value = input.toDouble();
  } else if (input is double) {
    value = input;
  } else if (input is String) {
    final normalized = input.replaceAll(',', '.').trim();
    value = double.tryParse(normalized) ?? 0.0;
  } else {
    value = 0.0;
  }

  final mod = pow(10.0, precision).toDouble();
  return (value * mod).roundToDouble() / mod;
}

int toInt<T>(T? input) {
  int value = 0;

  if (input == null || input.toString().trim().isEmpty) {
    return value;
  }

  if (input is int) {
    value = input;
  } else if (input is double) {
    value = input.round();
  } else if (input is String) {
    final normalized = input.replaceAll(',', '.').trim();
    final parsed = double.tryParse(normalized);
    if (parsed != null) {
      value = parsed.round();
    }
  }

  return value;
}

Future<File?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) {
    return null;
  }
  return File(image.path);
}
