class MessageModel {
  String messageId = "";
  String messageSenderId = "";
  String messageReceiverId = "";
  String messageBody = "click to start a chat";
  DateTime messageCreationDate = DateTime(1000);

  MessageModel();

  MessageModel.toModel(Map<String, dynamic> jsonMap) {
    messageId = jsonMap['messageId'] ?? "";
    messageBody = jsonMap['messageBody'] ?? "click to start a chat";
    messageSenderId = jsonMap['messageSenderId'] ?? "";
    messageReceiverId = jsonMap['messageReceiverId'] ?? ""; 
    messageCreationDate = jsonMap['messageCreationDate'] == null
        ? DateTime(1000)
        : jsonMap['messageCreationDate'].toDate();
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> jsonMap = <String, dynamic>{};
    jsonMap['messageId'] = messageId;
    jsonMap['messageBody'] = messageBody;
    jsonMap['messageSenderId'] = messageSenderId;
    jsonMap['messageReceiverId'] = messageReceiverId;
    jsonMap["messageCreationDate"] = DateTime.now();
    return jsonMap;
  }
}
