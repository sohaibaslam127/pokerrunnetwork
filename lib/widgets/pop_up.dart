import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showPopup(
  BuildContext context,
  String title,
  String button1,
  String button2,
  Function() button1Action,
  Function() button2Action,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: button1Action,
                        child: Image.asset("assets/icons/no.png", height: 5.h),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: button2Action,
                        child: Image.asset(
                          "assets/icons/copy.png",
                          height: 9.5.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
