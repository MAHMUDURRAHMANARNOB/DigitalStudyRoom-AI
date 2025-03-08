import 'package:flutter/material.dart';

class SubmitReactionProvider with ChangeNotifier {
  bool isLoading = false;
  bool isSubmitted = false;

  Future<bool> fetchSubmitReaction(String userId, String ticketId, String type, String category) async {
    try {
      isLoading = true;
      notifyListeners();  // Notify UI that loading started

      // Perform the API request or logic here
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      isSubmitted = true;
      isLoading = false;
      notifyListeners();  // Notify UI that submission is complete

      return true;  // Indicate success
    } catch (e) {
      isLoading = false;
      notifyListeners();  // Notify UI that loading stopped due to an error
      return false; // Indicate failure
    }
  }
}
