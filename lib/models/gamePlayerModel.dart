import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokerrunnetwork/config/global.dart';

class GamePlayerModel {
  String userId = '', roadName = '', userName = '', userImage = '';
  bool approved = false, changeCard = false;
  GeoPoint currentLocation = GeoPoint(0, 0);
  int changeCardAttempts = 0;
  double spends = 0;
  String pokerId = "";
  bool mycoRider = false, iamCoRider = false, isExtraCardCorider = false;
  String mycoRiderName = "";
  String rank = "";
  int rankValue = 0;
  int currentStop = 0;
  List<int> cards = [];

  GamePlayerModel();

  GamePlayerModel.toModel(Map<String, dynamic> jsonMap) {
    userId = jsonMap['userId'] ?? "";
    approved = jsonMap['approved'] ?? false;
    mycoRider = jsonMap['mycoRider'] ?? false;
    iamCoRider = jsonMap['iamCoRider'] ?? false;
    isExtraCardCorider = jsonMap['isExtraCardCorider'] ?? false;
    mycoRiderName = jsonMap['mycoRiderName'] ?? "";
    userImage = jsonMap['userImage'] ?? "";
    changeCard = jsonMap['changeCard'] ?? false;
    roadName = jsonMap['roadName'];
    userName = jsonMap['userName'];
    currentLocation = jsonMap['currentLocation'] ?? GeoPoint(0, 0);
    rank = jsonMap['rank'];
    rankValue = jsonMap['rankValue'];
    spends = jsonMap['spends'];
    cards = List<int>.from(jsonMap['cards']);
    currentStop = jsonMap['currentStop'];
    pokerId = jsonMap['pokerId'] ?? "";
    changeCardAttempts = jsonMap['changeCardAttempts'] ?? 0;
  }

  Map<String, dynamic> toSaveJSON() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['userId'] = userId;
    jsonMap['roadName'] = roadName.trim().toLowerCase();
    jsonMap['mycoRider'] = mycoRider;
    jsonMap['approved'] = approved;
    jsonMap['iamCoRider'] = iamCoRider;
    jsonMap['isExtraCardCorider'] = isExtraCardCorider;
    jsonMap['mycoRiderName'] = mycoRiderName.trim().toLowerCase();
    jsonMap['userImage'] = userImage;
    jsonMap['changeCard'] = changeCard;
    jsonMap['userName'] = userName;
    jsonMap['currentLocation'] = currentLocation;
    jsonMap['searchParameter'] = generateArray(roadName.trim().toLowerCase());
    jsonMap['currentStop'] = currentStop;
    jsonMap['pokerId'] = pokerId;
    jsonMap['cards'] = cards;
    jsonMap['rank'] = rank;
    jsonMap['rankValue'] = rankValue;
    jsonMap['changeCardAttempts'] = changeCardAttempts;
    jsonMap['spends'] = spends;
    return jsonMap;
  }
}
