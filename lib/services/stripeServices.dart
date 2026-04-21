import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/transaction.dart';

class StripeServices {
  static final StripeServices I = StripeServices._();
  StripeServices._();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );

  Future<void> init() async {
    Stripe.publishableKey =
        'pk_live_51LpebGHGnGSAxF3Sp1QiHafaMtkz5NvVMvhNWGHwzmjooXSi8x6fNtz4tbRSGSDGq5pw2ikbDeLW26WOuQvbiPKP00vXHBbVhU';
    await Stripe.instance.applySettings();
  }

  Future<bool> initPaymentSheet(
    BuildContext context,
    TransactionModel model,
    String email,
    String currency,
    double amount,
  ) async {
    if (amount <= 0) {
      return true;
    }

    try {
      EasyLoading.show(status: "Initializing Payment...");
      final response = await _dio.post(
        'https://us-central1-pokerapp-e17f8.cloudfunctions.net/stripePaymentIntentRequest',
        data: {
          'email': email,
          'amount': (amount * 100).toInt(),
          'currency': currency.toLowerCase(),
        },
      );

      if (response.data == null ||
          response.data['paymentIntent'] == null ||
          response.data['customer'] == null ||
          response.data['ephemeralKey'] == null) {
        throw Exception("Invalid response from server.");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response.data['paymentIntent'],
          merchantDisplayName: 'PokerApp',
          customerId: response.data['customer'],
          customerEphemeralKeySecret: response.data['ephemeralKey'],
          style: ThemeMode.system,
        ),
      );

      EasyLoading.dismiss();
      await Stripe.instance.presentPaymentSheet();

      model.stripeCustomerId = response.data['customer'];
      model.stripePaymentIntentClientSecret = response.data['paymentIntent'];

      return true;
    } catch (e) {
      EasyLoading.dismiss();
      _handleStripeError(context, e);
      return false;
    }
  }

  Future<bool> refundPayment(BuildContext context, String paymentId) async {
    try {
      EasyLoading.show(status: "Processing refund...");
      final response = await _dio.post(
        'https://us-central1-pokerapp-e17f8.cloudfunctions.net/stripePaymentRefund',
        data: {'pi_id': paymentId},
      );
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        toast(context, "Refund Successful", "Your payment has been refunded.");
        return true;
      } else {
        toast(context, "Refund Failed", "Unable to process refund.");
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      _handleStripeError(context, e);
      return false;
    }
  }

  void _handleStripeError(BuildContext context, dynamic e) {
    if (e is StripeException) {
      final msg = e.error.message ?? "Stripe error occurred.";
      debugPrint("StripeException: $msg");
      toast(context, "Stripe Error", msg);
    } else if (e is DioException) {
      final msg = e.response?.data['error'] ?? e.message ?? "Network error.";
      debugPrint("DioException: $msg");
      toast(context, "API Error", msg.toString());
    } else {
      debugPrint("Unexpected Error: $e");
      toast(context, "Unexpected Error", e.toString());
    }
  }
}
