// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:pokerrunnetwork/config/colors.dart';
// import 'package:pokerrunnetwork/page/auth/singup_page.dart';
// import 'package:pokerrunnetwork/page/home/Partner_list.dart';
// import 'package:pokerrunnetwork/page/home/progress_poker.dart';
// import 'package:pokerrunnetwork/widgets/custom_button.dart';
// import 'package:pokerrunnetwork/widgets/txt_field.dart';
// import 'package:pokerrunnetwork/widgets/txt_widget.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class CoManagerMenu extends StatefulWidget {
//   const CoManagerMenu({super.key});

//   @override
//   State<CoManagerMenu> createState() => _CoManagerMenuState();
// }

// class _CoManagerMenuState extends State<CoManagerMenu> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Color(0xff000435),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   onPress(
//                     ontap: () {
//                       Get.back();
//                     },
//                     child: Image.asset("assets/icons/bb.png", height: 3.h),
//                   ),

//                   SizedBox(height: 1.h),
//                   Center(
//                     child: Image.asset("assets/logo/logo.png", height: 24.h),
//                   ),
//                   SizedBox(height: 3.h),

//                   Center(
//                     child: text_widget(
//                       "Poker Run Player Affiliate Management Page",
//                       textAlign: TextAlign.center,

//                       fontSize: 22.sp,
//                       height: 1.1,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 3.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Image.asset(
//                           "assets/icons/p21.png",
//                           height: 16.h,
//                         ),
//                       ),
//                       // SizedBox(width: 1.w),
//                       Expanded(
//                         child: onPress(
//                           ontap: () {
//                             Get.to(PartnerList(type: null,));
//                           },
//                           child: Image.asset(
//                             "assets/icons/p22.png",
//                             height: 16.h,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: onPress(
//                           ontap: () {
//                             Get.to(ProgressPoker());
//                           },
//                           child: Image.asset(
//                             "assets/icons/p23.png",
//                             height: 16.h,
//                           ),
//                         ),
//                       ),
//                       // SizedBox(width: 1.w),
//                       Expanded(
//                         child: onPress(
//                           ontap: () {
//                             showDeleteAccountPopup(context);
//                           },
//                           child: Image.asset(
//                             "assets/icons/p24.png",
//                             height: 16.h,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.5.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void showDeleteAccountPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Close on tap outside
//       builder: (_) {
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 15),

//                   Text(
//                     "Are You Sure You Want To Remove Yourself From This Event As A Co-Manager?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),

//                   SizedBox(height: 10),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Cancel Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Image.asset(
//                             "assets/icons/yes.png",
//                             height: 10.h,
//                           ),
//                         ),
//                       ),

//                       // Delete Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                             // your delete logic here
//                           },
//                           child: Image.asset(
//                             "assets/icons/no.png",
//                             height: 5.h,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
