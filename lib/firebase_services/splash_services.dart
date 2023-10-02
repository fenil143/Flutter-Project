import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_connect/ui/app/homeScreen.dart';
// import 'package:firebase_connect/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../ui/auth/loginScreen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const homeScreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
