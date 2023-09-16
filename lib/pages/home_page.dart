import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidooo_chat_app/models/chat_room_model.dart';
import 'package:fidooo_chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fidooo Chat App"),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participants.${widget.userModel.uid}",
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        Map<String, dynamic> participants =
                            chatRoomModel.participants!;

                        List<String> participantKeys =
                            participants.keys.toList();
                        participantKeys.remove(widget.userModel.uid);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No hay Chats"),
                    );
                  }
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_sharp),
      ),
    );
  }
}
