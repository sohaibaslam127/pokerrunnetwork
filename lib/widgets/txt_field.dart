import 'package:flutter/material.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
Widget textFieldWithPrefixSuffuxIconAndHintText(
  String hintText, {
  suffixIcon,
  prefixIcon,
  bool showPrefix = false,       // ✅ control prefix visibility
  String? prefixImage,           // ✅ image path for prefix
  TextEditingController? controller,
  int line = 1,
  bool isSuffix = false,
  bool enable = true,
  TextInputType textInputType = TextInputType.text,
  double? radius,
  bool isTextSuffix = false,
  suffText,
  fillColor,
  bColor,
  mainTxtColor,
  pColor,
  hintColor,
  Function? onChange,
  bool obsecure = false,
}) {
  return StatefulBuilder(
    builder: (BuildContext _, setState) {
      return TextField(
        maxLines: line,
        keyboardType: textInputType,
        onChanged: (value) {
          if (onChange != null) {
            onChange();
          }
        },
        enabled: enable,
        obscureText: obsecure,
        cursorColor: Colors.grey.shade300,
        controller: controller,
        style: TextStyle(
          color: mainTxtColor ?? Colors.black54,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w400,
            color: hintColor ?? Colors.black54,
          ),
          
          // ✅ PREFIX ICON
          prefixIcon: showPrefix
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: prefixImage != null
                      ? Image.asset(
                          prefixImage,
                          height: 3.h,
                        )
                      : Icon(
                          prefixIcon ?? Icons.person,
                          size: 2.3.h,
                          color: Color(0xffACB5BB),
                        ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minHeight: 0,
            minWidth: 0,
          ),

          // ✅ SUFFIX ICON / TEXT
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: isTextSuffix
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: text_widget(
                    suffText,
                    fontSize: 14.6.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : suffixIcon.toString().contains("assets")
                  ? Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: onPress(
                        ontap: () {},
                        child: Image.asset(suffixIcon, height: 3.h),
                      ),
                    )
                  : isSuffix
                      ? Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: onPress(
                            ontap: () {
                              setState(() {
                                obsecure = !obsecure;
                              });
                            },
                            child: Icon(
                              suffixIcon ?? (obsecure
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined),
                              size: 2.3.h,
                              color: Color(0xffACB5BB),
                            ),
                          ),
                        )
                      : const SizedBox(),

          filled: true,
          fillColor: fillColor ?? Color(0xffF7F7F7),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(
              color: bColor ?? Colors.transparent,
              width: 1.4,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(
              color: bColor ?? Color(0xffE6DCCD),
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(color: MyColors.primary, width: 1.4),
          ),
        ),
      );
    },
  );
}



class PokerJoinDialog extends StatelessWidget {
  const PokerJoinDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Join',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3B70), // Deep Navy Blue
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Are You Sure You Want To Join\nThis Poker Run?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Inner Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Rider', '\$3.40'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(thickness: 0.8),
                  ),
                  _buildPriceRow('Total Paid To Organizer At Start', '\$3.40', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(child: Image.asset( PopupActionsButtons.no,height: 9.h,fit: BoxFit.cover,)),
                    const SizedBox(width: 10),
                
                // Yes Button (Gradient)
                Expanded(child: Image.asset( PopupActionsButtons.yes,height: 9.h,fit: BoxFit.cover,)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// How to call the dialog:
// showDialog(context: context, builder: (context) => const PokerJoinDialog());




class DeletePop extends StatelessWidget {
  const DeletePop({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Leave',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3B70), // Deep Navy Blue
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Are You Sure You Want To Leave\nThis Poker Run?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            // const SizedBox(height: 24),
  // const SizedBox(height: 15),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(child: Image.asset( PopupActionsButtons.no,height: 9.h,fit: BoxFit.cover,)),
                    const SizedBox(width: 10),
                
                // Yes Button (Gradient)
                Expanded(child: Image.asset( PopupActionsButtons.yes,height: 9.h,fit: BoxFit.cover,)),
              ],
            ),
           
          ],
        ),
      ),
    );
  }}


class DeletePop1 extends StatelessWidget {
  const DeletePop1({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Delete',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3B70), // Deep Navy Blue
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Are You Sure You Want To Delete?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            // const SizedBox(height: 24),
  // const SizedBox(height: 15),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(child: Image.asset( PopupActionsButtons.no,height: 9.h,fit: BoxFit.cover,)),
                    const SizedBox(width: 10),
                
                // Yes Button (Gradient)
                Expanded(child: Image.asset( PopupActionsButtons.yes,height: 9.h,fit: BoxFit.cover,)),
              ],
            ),
           
          ],
        ),
      ),
    );
  }}