import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';

class TransactionModel {
  String id = "";
  String stripePaymentIntentClientSecret = "";
  String stripeCustomerId = "";
  bool refund = false;
  double totalAmount = 0.0;

  String eventId = "";
  String eventCountryCode = "";
  String eventName = "";
  String organizerId = "";
  String organizerName = "";

  String userName = "";
  String userId = "";
  String userAccountType = "";
  String userAccountNumber = "";
  String userAccountEmail = "";
  String userAccountUserName = "";
  int transactionType = 0;
  int transactionStatus = 0;

  DateTime date = DateTime.now();
  TransactionModel();

  TransactionModel.toModel(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'] ?? '';
    refund = jsonMap['refund'] ?? '';
    stripePaymentIntentClientSecret =
        jsonMap['stripePaymentIntentClientSecret'] ?? '';
    stripeCustomerId = jsonMap['stripeCustomerId'] ?? '';
    totalAmount = (jsonMap['totalAmount'] ?? 0.0) + 0.0;
    eventId = jsonMap['eventId'] ?? '';
    eventCountryCode = jsonMap['eventCountryCode'] ?? 'US';
    eventName = jsonMap['eventName'] ?? '';
    organizerId = jsonMap['organizerId'] ?? '';
    organizerName = jsonMap['organizerName'] ?? '';
    userName = jsonMap['userName'] ?? '';
    userId = jsonMap['userId'] ?? '';
    userAccountType = jsonMap['userAccountType'] ?? '';
    userAccountNumber = jsonMap['userAccountNumber'] ?? '';
    userAccountEmail = jsonMap['userAccountEmail'] ?? '';
    userAccountUserName = jsonMap['userAccountUserName'] ?? '';
    transactionType = jsonMap['transactionType'] ?? 0;
    transactionStatus = jsonMap['transactionStatus'] ?? 0;
    date = jsonMap['date'].toDate();
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['id'] = id;
    jsonMap['stripePaymentIntentClientSecret'] =
        stripePaymentIntentClientSecret;
    jsonMap['stripeCustomerId'] = stripeCustomerId;
    jsonMap['organizerId'] = organizerId;
    jsonMap['refund'] = refund;
    jsonMap['totalAmount'] = totalAmount;
    jsonMap['eventCountryCode'] = countryCode;
    jsonMap['eventId'] = eventId;
    jsonMap['eventName'] = eventName;
    jsonMap['organizerName'] = organizerName;
    jsonMap['userName'] = userName;
    jsonMap['userId'] = userId;
    jsonMap['date'] = DateTime.now();
    jsonMap['userAccountType'] = userAccountType;
    jsonMap['userAccountNumber'] = userAccountNumber;
    jsonMap['userAccountEmail'] = userAccountEmail;
    jsonMap['userAccountUserName'] = userAccountUserName;
    jsonMap['transactionType'] = transactionType;
    jsonMap['transactionStatus'] = transactionStatus;
    jsonMap['searchParameter'] = generateArray(eventName);
    return jsonMap;
  }
}
