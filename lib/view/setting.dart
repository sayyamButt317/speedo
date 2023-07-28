import 'package:flutter/material.dart';
import '../Controller/getxcontroller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final Controller getxcontroller = Get.put<Controller>(Controller());

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Setting"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView(children: [
          ListTile(
            title: GestureDetector(onTap: () {}, child: const Text("Profile")),
            leading: const Icon(Icons.person),
          ),
          const ListTile(
            title: Text("Recharge Card"),
            leading: Icon(Icons.credit_card),
          ),
          const ListTile(
            title: Text("Recharge History"),
            leading: Icon(Icons.history),
          ),
          ListTile(
            title: GestureDetector(
                onTap: () => auth
                        .signOut()
                        .then((value) {})
                        .onError((error, stackTrace) {
                      Get.snackbar("Error", error.toString());
                    }),
                child: const Text("Logout")),
            leading: const Icon(Icons.lock),
          )
        ]));
  }
}
