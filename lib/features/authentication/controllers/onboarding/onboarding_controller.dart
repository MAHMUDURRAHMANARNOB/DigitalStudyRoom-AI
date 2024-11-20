import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/login/login.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  ///Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0
      .obs; //actually a observer, it will change the design without using stateful widget
  //an int, but using RX type which is the getx method to define variable which can easily be changed and which state is going to be changed on the design as well

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index) {
    currentPageIndex.value = index;
  }

  //Jump to the specific dot selected page
  void dotNavigationClicked(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index.toDouble());
  }

  //Update current index and jump to next page
  void nextPage(context) {
    if (currentPageIndex.value == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //update current index and jump to the last page
  void skipPage() {
    print("pressed");
    currentPageIndex.value = 2; // fixed to the last screen index
    pageController.jumpToPage(2);
  }
}
