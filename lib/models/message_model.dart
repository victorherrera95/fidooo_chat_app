class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  String? createdOn;

  MessageModel({this.sender, this.text, this.seen, this.createdOn, this.messageId});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = map["createdOn"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdOn,
    };
  }
}
