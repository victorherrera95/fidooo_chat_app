import 'package:fidooo_chat_app/models/firebase_helpers.dart';
import 'package:fidooo_chat_app/models/user_model.dart';
import 'package:fidooo_chat_app/pages/chat_room_page.dart';
import 'package:fidooo_chat_app/pages/complete_profile.dart';
import 'package:fidooo_chat_app/pages/home_page.dart';
import 'package:fidooo_chat_app/pages/login_page.dart';
import 'package:fidooo_chat_app/pages/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    //sesion iniciada
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);

    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(const MyApp());
    }
  } 
  else{
    //No ha iniciado sesion
    runApp(const MyApp());
  }
}

//Clase de inicio de sesion(sin haber iniciado)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//Clase de inicio de sesion(habiendo iniciado)
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
    {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}
