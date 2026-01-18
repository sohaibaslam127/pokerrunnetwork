import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
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
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      title.capitalize!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 80.w,
                  height: 10.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 2.5.w,
                        child: onPress(
                          ontap: button1Action,
                          child: Image.asset(
                            button1,
                            fit: BoxFit.fill,
                            width: 40.w,
                            height: 10.h,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2.5.w,
                        child: onPress(
                          ontap: button2Action,
                          child: Image.asset(
                            button2,
                            fit: BoxFit.fill,
                            width: 40.w,
                            height: 10.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class PokerResultDialog extends StatelessWidget {
  const PokerResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    currentGame.game.cards.length > 5
                        ? 5
                        : currentGame.game.cards.length,
                    (index) => Image.asset(
                      pokerCards[currentGame.game.cards[index]],
                      height: 88,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Winners Will Be Continue After The Poker Run.\nSee Result In My Poker Run List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hand: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentGame.game.rank.capitalize!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                onPress(
                  ontap: () {
                    Get.back();
                  },
                  child: Image.asset("assets/icons/gotit.png"),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: MyColors.secondaryDark,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/background/lightbackground.jpg",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Image.asset(
                      "assets/logo/logo.png",
                      width: 85,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the individual cards
  Widget _buildCardItem() {
    return Container(
      width: 55,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: NetworkImage(
            'https://placeholder.com/card',
          ), // Replace with your card asset
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
