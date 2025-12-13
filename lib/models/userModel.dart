import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokerrunnetwork/config/global.dart';

class UserModel {
  String id = "";
  String roadName = "";
  String email = "";
  String privateNote = "";
  String fcm = "";
  String image = "";
  GeoPoint location = GeoPoint(0.0, 0.0);
  String name = "";
  String number = "";
  bool? isUser;
  bool enable = true;
  int pokerRunCount = 0;
  int riderCount = 0;
  DateTime createdAt = DateTime.now();
  DateTime lastAppOpen = DateTime.now();

  UserModel();

  UserModel.toModel(Map<String, dynamic> jsonMap) {
    roadName = jsonMap['roadName'];
    email = jsonMap['email'];
    location = jsonMap['location'];
    fcm = jsonMap['fcm'];
    id = jsonMap['id'];
    isUser = jsonMap['isUser'];
    pokerRunCount = jsonMap['pokerRunCount'] ?? 0;
    privateNote = jsonMap['privateNote'];
    name = jsonMap['name'];
    number = jsonMap['number'];
    image = jsonMap['image'];
    riderCount = jsonMap['riderCount'] ?? 0;
    enable = jsonMap['enable'] ?? true;
    createdAt = jsonMap['createdAt'].toDate();
    lastAppOpen = jsonMap['lastAppOpen'].toDate();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['id'] = id;
    jsonMap['email'] = email;
    jsonMap['name'] = name;
    jsonMap['fcm'] = fcm;
    jsonMap['location'] = location;
    jsonMap['isUser'] = isUser;
    jsonMap['number'] = number;
    jsonMap['roadName'] = roadName.toLowerCase();
    jsonMap['image'] = image;
    jsonMap['searchParameter'] = generateArray(roadName);
    jsonMap['privateNote'] = privateNote;
    jsonMap['createdAt'] = createdAt;
    jsonMap['lastAppOpen'] = lastAppOpen;
    return jsonMap;
  }
}
