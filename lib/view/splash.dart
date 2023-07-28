import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speedo/repository/googleauth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => AuthService().handleAuthState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent, 
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.height * 0.3,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle, 
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              'images/bus-icon.png',
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
