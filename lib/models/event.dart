import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:pokerrunnetwork/config/supportFunctions.dart';
import 'package:pokerrunnetwork/models/gamePlayerModel.dart';
import 'package:pokerrunnetwork/models/stops.dart';

// "Status: ${void event.status == 0
//                     ? 'Disable'
//                     : void event.status == 1
//                     ? 'Scheduled'
//                     : void event.status == 2
//                     ? 'Completed'
//                     : void event.status == 3
//                     ? 'Cancel'
//                     : void event.status == 4
//                     ? 'Reshedule'
//                     : ''}",
class EventModel {
  String id = "";
  int status = 1;
  String ownerId = '';
  List<String> coManagers = [];
  List<String> coManagerNames = [];
  String ownerName = '', ownerImage = '';
  String taxIdentificationNumber = "";
  DateTime eventDate = DateTime(1000);
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
    coRiderFee = toDouble(jsonMap['coRiderFee']);
    coRider = jsonMap['coRider'];
    ownerImage = jsonMap['ownerImage'];
    coManagers = List<String>.from(jsonMap['coManagers'] ?? []);
    coManagerNames = List<String>.from(jsonMap['coManagerNames'] ?? []);
    id = jsonMap['id'];
    status = toInt(jsonMap['status']);
    isAdditionalCard = jsonMap['isAdditionalCard'] ?? false;
    pokerName = jsonMap['pokerName'].toString().trim();
    cancelReason = jsonMap['cancelReason'];
    taxIdentificationNumber = jsonMap['taxIdentificationNumber'] ?? "";
    description = jsonMap['description'];
    stops = ((jsonMap['stops'] ?? []) as List)
        .map((e) => StopsModel.toModel(e))
        .toList();
    userIds = List<String>.from(jsonMap['userIds'] ?? []);
    eventWinner = jsonMap['eventWinner'] != null
        ? GamePlayerModel.toModel(jsonMap['eventWinner'])
        : null;

    eventDate = DateTime.parse(jsonMap['eventDate']);
    changeCardFee = toDouble(jsonMap['changeCardFee']);
    joinFee = toDouble(jsonMap['joinFee']);
  }

  Future<Map<String, dynamic>> toSaveJSON() async {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['id'] = id;
    jsonMap['status'] = toInt(status);
    jsonMap['ownerId'] = ownerId;
    jsonMap['ownerName'] = ownerName;
    jsonMap['countryCode'] = countryCode;
    jsonMap['ownerImage'] = ownerImage;
    jsonMap['coManagers'] = coManagers;
    jsonMap['coManagerNames'] = coManagerNames;
    jsonMap['cancelReason'] = cancelReason;
    jsonMap['coRider'] = coRider;
    jsonMap['coRiderFee'] = toDouble(coRiderFee);
    jsonMap['pokerName'] = pokerName;
    jsonMap['eventWinner'] = eventWinner?.toSaveJSON();
    jsonMap['description'] = description;
    jsonMap["eventDate"] = eventDate.toString();
    jsonMap['searchParameter'] = generateArray(pokerName);
    jsonMap['changeCardFee'] = toDouble(changeCardFee);
    jsonMap['joinFee'] = toDouble(joinFee);
    jsonMap['isAdditionalCard'] = isAdditionalCard;
    jsonMap['taxIdentificationNumber'] = taxIdentificationNumber;
    jsonMap['stops'] = stops.map((e) => e.toSaveJSON()).toList();
    jsonMap['userIds'] = userIds;
    jsonMap['pokerName'] = pokerName;
    jsonMap['createdAt'] = Timestamp.fromDate(createdAt);
    return jsonMap;
  }
}
