import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget onPress({Function? ontap, Widget? child}) {
  return InkWell(
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () {
      if (ontap != null) {
        ontap();
      }
    },
    child: child,
  );
}


Widget customButon({bool isIcon = false, String? btnText, Function? onTap,String? icon}) {
  return  Center(child: onPress(
    ontap: (){
      if(onTap != null){
        onTap();
      }
    },
    child: Stack(
                                children: [
                                  Image.asset(
                                
                                    "assets/icons/btn.png",width: Get.width,fit: BoxFit.fill, ),
                                  Positioned.fill(child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Spacer(),
                                        Container(
                                          height: 6.h,
                                          margin: EdgeInsets.only(bottom: 1.h),
                                          // color: Colors.red,
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              isIcon ? Row(
                                                children: [
                                                  Spacer(),
                                                  Image.asset(icon!,height: 2.8.h,),
                                                  SizedBox(width: 1.6.w,),
                                                  text_widget(btnText??'' ,
                                                      fontSize: 17.6.sp,
                                                      // textAlign: TextAlign.center,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff113559)
                                                  ),
                                                  Spacer(),

                                                ],
                                              ) : 
                                              text_widget(btnText ?? "",
                                                  fontSize: 17.6.sp,
                                                  textAlign: TextAlign.center,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff113559)
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
    
                                      ],
                                    ),
                                  ))
                                ],
                              ),
  ));
}