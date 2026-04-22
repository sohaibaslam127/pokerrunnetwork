class SponsorsModel {
  List<int> stop = [];
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
    stop = List<int>.from(jsonMap['stop'] ?? []);
  }
  Map<String, dynamic> toSaveJSON() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['name'] = name;
    jsonMap['link'] = link;
    jsonMap['id'] = id;
    jsonMap['enable'] = enable;
    jsonMap['stops'] = stop;
    return jsonMap;
  }
}
