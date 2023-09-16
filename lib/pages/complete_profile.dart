import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fidooo_chat_app/models/user_model.dart';
import 'package:fidooo_chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfilePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedImage != null) {
      File? croppedFile = File(croppedImage.path);
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cargar foto de perfil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Seleccionar desde galeria"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Tomar Foto"),
                ),
              ],
            ),
          );
        });
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname = fullname;
    widget.userModel.profilepicture = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Perfil de usuario"),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              padding: const EdgeInsets.all(0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: (imageFile == null)
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Nombre Completo"),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
                onPressed: () {
                  uploadData();
                },
                color: Theme.of(context).colorScheme.primary,
                child: const Text(
                  "Acceder",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      )),
    );
  }
}
