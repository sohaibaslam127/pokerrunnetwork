import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pokerrunnetwork/config/colors.dart';
import 'package:pokerrunnetwork/models/event.dart';
import 'package:pokerrunnetwork/services/firestoreServices.dart';
import 'package:pokerrunnetwork/widgets/pop_up.dart';
import 'package:pokerrunnetwork/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QrScannerScreen extends StatefulWidget {
  final EventModel eventModel;
  const QrScannerScreen({super.key, required this.eventModel});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _processing = false;
  String? _lastResult;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw == _lastResult) return;

    _lastResult = raw;
    final parts = raw.split('|');
    if (parts.length != 2) {
      _showResult(success: false, message: "Invalid QR code");
      return;
    }

    final scannedUserId = parts[0];
    final scannedEventId = parts[1];

    if (scannedEventId != widget.eventModel.id) {
      _showResult(
        success: false,
        message: "This player is not registered for this event",
      );
      return;
    }

    setState(() => _processing = true);
    await _controller.stop();

    final game = await FirestoreServices.I.getGamePlayer(
      scannedEventId,
      scannedUserId,
    );

    if (game.pokerId.isEmpty) {
      _showResult(success: false, message: "Player not found in this event");
      return;
    }

    if (game.approved) {
      _showResult(
        success: true,
        message: "${game.roadName.capitalizeFirst} is already approved",
        alreadyApproved: true,
      );
      return;
    }

    game.approved = true;
    await FirestoreServices.I.updateGamePlayer(game);

    _showResult(
      success: true,
      message: "${game.roadName.capitalizeFirst} approved!",
    );
  }

  void _showResult({
    required bool success,
    required String message,
    bool alreadyApproved = false,
  }) {
    CustomPopups.showScanResult(
      context,
      success: success,
      message: message,
      alreadyApproved: alreadyApproved,
      onScanNext: () {
        Get.back();
        _lastResult = null;
        setState(() => _processing = false);
        _controller.start();
      },
      onDone: () {
        Get.back();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 9.w,
        leading: Padding(
          padding: EdgeInsets.only(bottom: 2.5, left: 1.5.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              RemixIcons.arrow_left_s_line,
              size: 25.sp,
              color: Colors.white,
            ),
          ),
        ),
        title: text_widget(
          "Scan Player QR",
          fontSize: 17.sp,
          color: Colors.white.withOpacity(0.85),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: Icon(RemixIcons.flashlight_line, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(height: 2, color: Colors.white12),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          // Overlay frame
          Center(
            child: Container(
              width: 65.w,
              height: 65.w,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.primary, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Bottom hint
          Positioned(
            bottom: 6.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: text_widget(
                  "Point camera at player's QR code",
                  fontSize: 15.sp,
                  color: Colors.white70,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (_processing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: MyColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
