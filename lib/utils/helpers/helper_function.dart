import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunction {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(context) {
    return MediaQuery.of(context!).size;
  }

  static double screenHeight(context) {
    return MediaQuery.of(context!).size.height;
  }

  static double screenWidth(context) {
    return MediaQuery.of(context!).size.width.toDouble();
  }
}
