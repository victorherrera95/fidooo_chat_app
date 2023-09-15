import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
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
          padding: const EdgeInsets.symmetric(
            horizontal: 40
          ),
          child: ListView(
            children: [
              const SizedBox(height: 20,),
        
               CupertinoButton(
                onPressed: () {},
                padding: const EdgeInsets.all(0),
                 child: const CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person, size: 60),
                             ),
               ),
        
              const SizedBox(height: 20,),
        
              const TextField(
                decoration: InputDecoration(
                  labelText: "Nombre Completo"
                ),
              ),

              const SizedBox(height: 20,),

              CupertinoButton(
              onPressed: (){},
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                "Acceder",
                style: TextStyle(fontSize: 18),
              )
              )
            ],
          ),
        )),
    );
  }
}