import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speedo/repository/googleauth.dart';

import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Image(
                      image: AssetImage("images/location-map.gif"),
                    )),
                const SizedBox(height: 20),
                Text(
                  "Track Your Ride",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900),
                ),
                Text(
                  "Easy as You Think!",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey.shade900),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                        onPressed: () {
                          AuthService().signInWithGoogle();
                        },
                        color: Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.blueGrey)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              Text("Login with Gmail ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                              Spacer(),
                            ]))),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                        onPressed: () => Get.to(() => const Login()),
                        color: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey.shade300)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              Text("Login via Email ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              Spacer(),
                            ])))
              ])),
        ),
      ),
    );
  }
}
