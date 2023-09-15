import 'package:fidooo_chat_app/models/user_model.dart';
import 'package:fidooo_chat_app/pages/complete_profile.dart';
import 'package:fidooo_chat_app/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, llene todos los campos'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('La contraseña no coincide'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(err.code.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid : uid,
        email: email,
        fullname: "",
        profilepicture: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(
        newUser.toMap()).then((value) {
          showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Nuevo Usuario Creado'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
        });
    }

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Fidooo Chat App",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña (minimo 6 caracteres)"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirmar Contraseña"),
              ),
              const SizedBox(
                height: 30,
              ),
              CupertinoButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  checkValues();
                },
                child: const Text("Confirmar Registro"),
              )
            ],
          )),
        ),
      )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Ya posee una cuenta?",
            style: TextStyle(fontSize: 18),
          ),
          CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }),
                );
              },
              child: const Text(
                "Acceder",
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
    );
  }
}
