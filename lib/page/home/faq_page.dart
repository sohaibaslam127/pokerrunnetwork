import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/widgets/ontap.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool faq=false;
    List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Image.asset(
          "assets/icons/bbg.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
            appBar: AppBar(
        foregroundColor: Colors.white.withOpacity(0.08),
          surfaceTintColor:Colors.white.withOpacity(0.08),
          backgroundColor:Colors.white.withOpacity(0.08),

          elevation: 0,
          leadingWidth: 14.w,
            leading: Padding(
            padding:  EdgeInsets.only(left:17.0),
            child: onPress(
              ontap: (){
                Get.back();
              },
              child: Icon(RemixIcons.arrow_left_s_line,size: 24.sp,color:Colors.white.withOpacity(0.80),),),
          ),
          title: text_widget("FAQ’s & Videos",
              fontSize: 16.6.sp,
              color: Colors.white.withOpacity(0.80),
          fontWeight: FontWeight.w600,
          ),
          centerTitle: false,
       
          
        ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
              Center(
  child: onPress(
    ontap: () {
      setState(() {
        faq = !faq;
      });
    },
    child: AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: Image.asset(
        faq ? "assets/icons/faq1.png" : "assets/icons/faq0.png",
        key: ValueKey(faq), // Must add to animate swap
        height: 8.h,
      ),
    ),
  ),
),
SizedBox(height: 3.h),
faq == true ?Column(
  children: [
    ...List.generate(4, (index){
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: Row(
            children: [
              Image.asset("assets/icons/video.png",height: 12.h,),
              SizedBox(width: 4.w,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_widget("Prepare for your first skateboard jump",
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 1.h,),
                  text_widget("Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  color: Colors.white.withOpacity(0.70),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  ),
                ],
              ))
            ],
          ),
        ),
      );
    })
  ]
)  :  Column(
                children:[
     ...List.generate(
                    faqs.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 22),
                      child: Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            border: Border.all(
                              color: const Color(0xffFFFFFF).withOpacity(0.30), // ✅ border color
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: faqs[index],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            tilePadding: const EdgeInsets.all(08),
                            
                            controlAffinity: ListTileControlAffinity.trailing,
                            onExpansionChanged: (value) {
                              setState(() {
                                faqs[index] = value;
                              });
                            },
                            title: text_widget(
                              "How to create a account?",
                              color: Colors.white,
                              fontSize: 15.5.sp,
                            ),
                            iconColor: MyColors.primary,
                            trailing: faqs[index] == true
                                ? Icon(
                                    Remix.close_fill,
                                    color: Color(0xff7E82B4),
                                  )
                                : Icon(Remix.add_line, color: Color(0xff7E82B4)),
                            children: [
                              text_widget(
                                "Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.",
                                color: Colors.white.withOpacity(0.70),
                                fontSize: 15.sp,
                              ),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ]),

              ],
            ),
          ),
        ),
      ],
    );
  }
}