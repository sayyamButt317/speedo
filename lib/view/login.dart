import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedo/view/signup.dart';
import 'home.dart';
import '../Controller/getxcontroller.dart';

import 'profile.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final List<String> _images = [
    'https://ouch-cdn2.icons8.com/tSgdQCON_ry4WkBETVT2kz7ft-FOWw_27mVFNzILxuk/rs:fit:256:192/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvOTA1/L2JhMTA3MjE5LTli/YzktNGQ4Yy04NzZi/LTM5MmFkY2VjOGY0/Yy5zdmc.png',
    'https://ouch-cdn2.icons8.com/d0nj1Z_jOO5ZZmFKJPYFNFlPkCO9ORVGxr9rrDN_kMg/rs:fit:256:162/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNjk0/LzQyYTEwMjgyLTQx/NjctNDdjZS04MTkx/LWY1ZWI0M2Y4MTMw/Mi5zdmc.png',
    "https://ouch-cdn2.icons8.com/rn7UiCFEGMbuxJ8MxZSSRgw-QAbUyaeoaQDll5FyYDk/rs:fit:512:384/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvMzk3/L2RjNDIyMjQ2LTJk/NDQtNDU0YS05Mjdm/LTU4MGQ3MjA0OTY3/ZS5wbmc.png",
  ];
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final auth = FirebaseAuth.instance;

  final Controller getxcontroller = Get.put<Controller>(Controller());

  startTimer() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getxcontroller
          .activeIndex.value++; // Accessing the int value using .value
      if (getxcontroller.activeIndex.value == 3) {
        getxcontroller.activeIndex.value =
            0; // Assigning a new value using .value
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final String email = _email.text.trim();
      final String password = _password.text.trim();
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // Redirect the user
      final User? user = auth.currentUser;
      if (user != null) {
        Get.offAll(() => const Profile());
      } else {
        Get.offAll(() => const HomePage());
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'An error occurred while logging in';
      if (error.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Invalid password';
      }

      debugPrint(error.toString());

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        colorText: Colors.red,
        borderWidth: 1,
        borderColor: Colors.red,
      );
      getxcontroller.isprofileloading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 300,
              child: Stack(
                children: _images.asMap().entries.map((e) {
                  return Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity:
                          getxcontroller.activeIndex.value == e.key ? 1 : 0,
                      child: Image.network(
                        e.value,
                        height: 400,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Email";
                      }
                      return null;
                    },
                    controller: _email,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.alternate_email,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Password";
                      }
                      return null;
                    },
                    controller: _password,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  getxcontroller.isprofileloading(true);
                  await login();
                }
              },
              height: 50,
              minWidth: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.black,
              child: Obx(() {
                return getxcontroller.isprofileloading.value
                    ? const CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.white)
                    : const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account?",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const Signup()),
                  child: const Text(
                    'SignUp?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
