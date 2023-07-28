import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speedo/view/home.dart';
import 'package:speedo/view/onboarding.dart';
import 'package:speedo/view/profile.dart';

class AuthService {
  //Signout Determine user is authenticated
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const WelcomeScreen();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, get the user's location
    Position? position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Handle location error
      debugPrint('Error getting user location: $e');
    }

    // Store the location data in Firebase
    if (position != null) {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child("userslocation");
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        databaseReference.child(user.uid).set({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      }
    }

    // Redirect the user
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? firebaseUser = userCredential.user;
    if (firebaseUser != null) {
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        Get.offAll(() => const Profile());
      } else {
        Get.offAll(() => const HomePage());
      }
    } else {
      // Handle authentication error
      debugPrint('Error authenticating user');
    }
  }
}
