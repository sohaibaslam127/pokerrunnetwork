import 'package:cloud_firestore/cloud_firestore.dart';

class SponsorsModel {
  List<int> stops = [];
  String name = "";
  String link = "";
  String id = "";
  bool enable = true;
  SponsorsModel();

  SponsorsModel.toModel(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] ?? '';
    link = jsonMap['link'] ?? '';
    id = jsonMap['id'] ?? '';
    enable = jsonMap['enable'] ?? true;
    stops = List<int>.from(jsonMap['stops'] ?? []);
  }
  Map<String, dynamic> toSaveJSON() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['name'] = name;
    jsonMap['link'] = link;
    jsonMap['id'] = id;
    jsonMap['enable'] = enable;
    jsonMap['stops'] = stops;
    return jsonMap;
  }
}