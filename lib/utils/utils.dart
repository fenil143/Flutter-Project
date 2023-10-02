import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

class utils {
  void toastMessage(String message, {bool check = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:
          check ? Colors.green : Colors.red, // Set background color
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
