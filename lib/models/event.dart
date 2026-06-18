import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:intl/intl.dart';
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
  bool isShotgun = false; // is golf
  List<String> coManagerNames = [];
  String ownerName = '', ownerImage = '';
  String taxIdentificationNumber = "";
  DateTime eventDate = DateTime(1000);
  double changeCardFee = 0.00;
  double joinFee = 0.00;
  String countryCode = "US";
  bool autoApproved = false;
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
    autoApproved = jsonMap['autoApproved'] ?? false;
    isShotgun = jsonMap['isShotgun'] ?? false;
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
    jsonMap['isShotgun'] = isShotgun;
    jsonMap['cancelReason'] = cancelReason;
    jsonMap['autoApproved'] = autoApproved;
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

  EventModel copyWith({
    String? id,
    int? status,
    String? ownerId,
    List<String>? coManagers,
    List<String>? coManagerNames,
    String? ownerName,
    bool? autoApproved,
    String? ownerImage,
    String? taxIdentificationNumber,
    DateTime? eventDate,
    double? changeCardFee,
    double? joinFee,
    String? countryCode,
    Country? currency,
    double? coRiderFee,
    bool? isShotgun,
    String? pokerName,
    String? description,
    String? cancelReason,
    bool? isAdditionalCard,
    bool? coRider,
    DateTime? createdAt,
    List<StopsModel>? stops,
    List<String>? userIds,
    GamePlayerModel? eventWinner,
  }) {
    EventModel model = EventModel();

    model.id = id ?? this.id;
    model.status = status ?? this.status;
    model.ownerId = ownerId ?? this.ownerId;
    model.ownerName = ownerName ?? this.ownerName;
    model.isShotgun = isShotgun ?? this.isShotgun;
    model.ownerImage = ownerImage ?? this.ownerImage;
    model.autoApproved = autoApproved ?? this.autoApproved;
    model.taxIdentificationNumber =
        taxIdentificationNumber ?? this.taxIdentificationNumber;

    model.countryCode = countryCode ?? this.countryCode;
    model.currency = currency ?? this.currency;

    model.eventDate = eventDate != null
        ? DateTime.fromMillisecondsSinceEpoch(eventDate.millisecondsSinceEpoch)
        : DateTime.fromMillisecondsSinceEpoch(
            this.eventDate.millisecondsSinceEpoch,
          );

    model.createdAt = DateTime.now();

    model.changeCardFee = changeCardFee ?? this.changeCardFee;
    model.joinFee = joinFee ?? this.joinFee;
    model.coRiderFee = coRiderFee ?? this.coRiderFee;

    model.coRider = coRider ?? this.coRider;
    model.isAdditionalCard = isAdditionalCard ?? this.isAdditionalCard;

    model.pokerName = pokerName ?? this.pokerName;
    model.description = description ?? this.description;
    model.cancelReason = cancelReason ?? this.cancelReason;

    model.coManagers = List<String>.from(coManagers ?? this.coManagers);
    model.coManagerNames = List<String>.from(
      coManagerNames ?? this.coManagerNames,
    );
    model.userIds = List<String>.from(userIds ?? this.userIds);

    model.stops = (stops ?? this.stops)
        .map((e) => StopsModel.toModel(e.toSaveJSON()))
        .toList();

    model.eventWinner = eventWinner != null
        ? GamePlayerModel.toModel(eventWinner.toSaveJSON())
        : this.eventWinner != null
        ? GamePlayerModel.toModel(this.eventWinner!.toSaveJSON())
        : null;

    return model;
  }
}
