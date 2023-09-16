import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidooo_chat_app/models/chat_room_model.dart';
import 'package:fidooo_chat_app/models/message_model.dart';
import 'package:fidooo_chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {super.key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Mensaje enviado
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdOn: DateTime.now().toString(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepicture.toString()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          //Lista de conversaciones
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return Row(
                            mainAxisAlignment:
                                (currentMessage.sender == widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? Colors.grey
                                        : Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Ocurrio un error, revise su conexion"),
                      );
                    } else {
                      return const Center(child: Text("Hola Desde Aca"));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),

          Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    maxLines: null,
                    controller: messageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Mensaje"),
                  )),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ))
        ],
      )),
    );
  }
}
