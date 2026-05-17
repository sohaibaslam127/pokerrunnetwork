import 'dart:io';
import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomAdInlineWidget extends StatefulWidget {
  final Key? widgetKey;
  final double? height;
  final double? radius;
  final bool isMedium;
  const CustomAdInlineWidget({
    super.key,
    this.widgetKey,
    this.height,
    this.radius,
    this.isMedium = false,
  });

  @override
  State<CustomAdInlineWidget> createState() => _CustomAdInlineWidgetState();
}

class _CustomAdInlineWidgetState extends State<CustomAdInlineWidget> {
  // Stable key to prevent unnecessary ad reloads during parent rebuilds
  late final Key _stableKey;

  @override
  void initState() {
    super.initState();
    // If widgetKey is provided, use it. Otherwise, generate a stable one for this instance.
    _stableKey = widget.widgetKey ?? UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    if (!enableAds) {
      return const SizedBox.shrink();
    }

    final double adHeight = widget.height ?? 107.0;
    final double adRadius = widget.radius ?? 10;

    return Container(
      width: double.infinity,
      height: adHeight,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(adRadius),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(adRadius),
        child: Stack(
          children: [
            Shimmer(
              duration: const Duration(seconds: 2),
              interval: const Duration(seconds: 1),
              color: Colors.white,
              colorOpacity: 0.1,
              enabled: true,
              direction: const ShimmerDirection.fromLBRT(),
              child: Container(
                width: double.infinity,
                height: adHeight,
                color: Colors.white12,
              ),
            ),

            // Admob Native Ad
            widget.isMedium || adHeight > 30.h
                ? Center(
                    child: AdmobNativeAd.medium(
                      key: _stableKey,
                      backgroundColor: Colors.transparent,
                      height: 320,
                    ),
                  )
                : Center(
                    child: AdmobNativeAd.small(
                      key: _stableKey,
                      backgroundColor: Colors.transparent,
                      height: adHeight,
                    ),
                  ),

            // "Sponsored" label
            Positioned(
              top: 4,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Sponsored",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: widget.isMedium ? 13.sp : 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
