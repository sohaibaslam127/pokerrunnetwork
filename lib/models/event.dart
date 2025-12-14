import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:pokerrunnetwork/config/global.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/models/stops.dart';

class EventModel {
  String id = "";
  int status = 1;
  String ownerId = '';
  String ownerName = '', ownerImage = '';
  String taxIdentificationNumber = "";
  DateTime eventDate = DateTime(1000);
  DateTime date = DateTime(1000);
  int eventTimezone = 0;
  double changeCardFee = 0.00;
  double joinFee = 0.00;
  String countryCode = "US";
  Country currency = Country(isoCode: 'US');
  double coRiderFee = 0.00;
  String pokerName = "";
  String description = "";
  String cancelReason = "";
  bool? isAdditionalCard, coRider;
  DateTime createdAt = DateTime.now();
  List<StopsModel> stops = [
    StopsModel(),
    StopsModel(),
    StopsModel(),
    StopsModel(),
    StopsModel(),
    StopsModel(),
    StopsModel(),
  ];
  List<String> userIds = [];
  GamePlayerModel? eventWinner;
  EventModel();

  EventModel.toModel(Map<String, dynamic> jsonMap) {
    ownerId = jsonMap['ownerId'];
    countryCode = jsonMap['countryCode'] ?? "US";
    try {
      currency = CountryPickerUtils.getCountryByIsoCode(countryCode);
    } catch (e) {
      currency = CountryPickerUtils.getCountryByIsoCode('US');
    }
    ownerName = jsonMap['ownerName'];
    createdAt = jsonMap['createdAt'].toDate();
    coRiderFee = jsonMap['coRiderFee'] + 0.0;
    coRider = jsonMap['coRider'];
    ownerImage = jsonMap['ownerImage'];
    id = jsonMap['id'];
    status = jsonMap['status'];
    isAdditionalCard = jsonMap['isAdditionalCard'] ?? false;
    pokerName = jsonMap['pokerName'].toString().trim();
    cancelReason = jsonMap['cancelReason'];
    taxIdentificationNumber = jsonMap['taxIdentificationNumber'] ?? "";
    description = jsonMap['description'];
    stops = ((jsonMap['stops'] ?? []) as List)
        .map((e) => StopsModel.toModel(e))
        .toList();
    userIds = List<String>.from(jsonMap['userIds'] ?? []);
    eventTimezone = jsonMap['eventTimezone'] ?? 0;
    eventWinner = jsonMap['eventWinner'] != null
        ? GamePlayerModel.toModel(jsonMap['eventWinner'])
        : null;

    if (jsonMap['eventDate'] is Timestamp) {
      jsonMap['eventDate'] = jsonMap['eventDate'].toDate();
    }

    date = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).parse(jsonMap['eventDate'].toString(), false);

    changeCardFee =
        jsonMap['changeCardFee'] == "" || jsonMap['changeCardFee'] == null
        ? 0.0
        : jsonMap['changeCardFee'] + 0.0;
    joinFee = jsonMap['joinFee'] == "" || jsonMap['joinFee'] == null
        ? 0.0
        : jsonMap['joinFee'] + 0.0;
  }

  Future<Map<String, dynamic>> toSaveJSON() async {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['id'] = id;
    jsonMap['status'] = status;
    jsonMap['ownerId'] = ownerId;
    jsonMap['ownerName'] = ownerName;
    jsonMap['countryCode'] = countryCode;
    jsonMap['ownerImage'] = ownerImage;
    jsonMap['cancelReason'] = cancelReason;
    jsonMap['coRider'] = coRider;
    jsonMap['coRiderFee'] = coRiderFee + 0.0;
    jsonMap['pokerName'] = pokerName;
    jsonMap['eventWinner'] = eventWinner?.toSaveJSON();
    jsonMap['description'] = description;
    jsonMap["eventDate"] = eventDate.toString();
    jsonMap['searchParameter'] = generateArray(pokerName);
    jsonMap['changeCardFee'] = changeCardFee + 0.0;
    jsonMap['joinFee'] = joinFee + 0.0;
    jsonMap['isAdditionalCard'] = isAdditionalCard;
    jsonMap['taxIdentificationNumber'] = taxIdentificationNumber;
    jsonMap['stops'] = stops.map((e) => e.toSaveJSON()).toList();
    jsonMap['userIds'] = userIds;
    jsonMap['pokerName'] = pokerName;
    jsonMap['createdAt'] = Timestamp.fromDate(createdAt);
    return jsonMap;
  }
}
