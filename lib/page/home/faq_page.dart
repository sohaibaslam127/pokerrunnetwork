import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/custom_button.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Map<String, dynamic>> videos = [];
  List<Map<String, dynamic>> faqs = [];
  List<bool> faqExpanded = [];
  bool isFaqs = true;

  @override
  void initState() {
    super.initState();
    getHelp();
  }

  Future<void> getHelp() async {
    EasyLoading.show();
    final faqResult = await FirestoreServices.I.getFaqs();
    EasyLoading.dismiss();
    final videoResult = await FirestoreServices.I.getVideos();

    setState(() {
      faqs = faqResult;
      videos = videoResult;
      faqExpanded = List.generate(faqs.length, (_) => false);
    });
  }

  void playYoutubeVideo(BuildContext context, String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: MyColors.primary,
          ),
        ),
      ),
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background/darkbackground.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent.withValues(alpha: .2),
            leadingWidth: 8.w,
            leading: Padding(
              padding: const EdgeInsets.only(left: 17),
              child: onPress(
                ontap: () => Get.back(),
                child: Icon(
                  RemixIcons.arrow_left_s_line,
                  size: 24.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
            title: text_widget(
              "FAQ’s & Videos",
              fontSize: 17.sp,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: onPress(
                    ontap: () => setState(() => isFaqs = !isFaqs),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        isFaqs
                            ? "assets/icons/faq0.png"
                            : "assets/icons/faq1.png",
                        key: ValueKey(isFaqs),
                        height: 8.5.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),

                /// ---------------- VIDEOS ----------------
                if (!isFaqs)
                  Column(
                    children: [
                      if (videos.isEmpty) text_widget("No Video available."),
                      ...List.generate(videos.length, (index) {
                        final videoId = YoutubePlayer.convertUrlToId(
                          videos[index]['link'],
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 22,
                          ),
                          child: onPress(
                            ontap: () => playYoutubeVideo(
                              context,
                              videos[index]['link'],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        YoutubePlayer.getThumbnail(
                                          videoId: videoId!,
                                          quality: ThumbnailQuality.medium,
                                        ),
                                        width: 12.h,
                                        height: 9.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text_widget(
                                        videos[index]['title']
                                            .toString()
                                            .capitalizeFirst!,
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        maxline: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 0.2.h),
                                      text_widget(
                                        videos[index]['description']
                                            .toString()
                                            .capitalizeFirst!,
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        maxline: 3,
                                        fontSize: 14.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                /// ---------------- FAQS ----------------
                if (isFaqs)
                  Column(
                    children: [
                      if (faqs.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 32.h),
                          child: text_widget(
                            "NO FAQS AVAILABLE",
                            color: Colors.white38,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ...List.generate(faqs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 22,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: faqExpanded[index],
                              onExpansionChanged: (v) =>
                                  setState(() => faqExpanded[index] = v),
                              title: text_widget(
                                "${index + 1}. ${faqs[index]['question']}",
                                color: Colors.white,
                                fontSize: 15.5.sp,
                              ),
                              trailing: Icon(
                                faqExpanded[index]
                                    ? Remix.close_fill
                                    : Remix.add_line,
                                color: const Color(0xff7E82B4),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: text_widget(
                                    faqs[index]['answer'],
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
