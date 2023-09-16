class ChatRoomModel {
  String? chatroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatroomId, this.participants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomId = map["chatroomId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomId": chatroomId,
      "participants": participants,
      "lastMessage": lastMessage,
    };
  }
}
