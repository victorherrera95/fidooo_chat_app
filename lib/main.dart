
import 'package:fidooo_chat_app/pages/complete_profile.dart';
import 'package:fidooo_chat_app/pages/home_page.dart';
import 'package:fidooo_chat_app/pages/login_page.dart';
import 'package:fidooo_chat_app/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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
