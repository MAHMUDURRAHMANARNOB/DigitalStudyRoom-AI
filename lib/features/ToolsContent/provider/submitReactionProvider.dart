import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../datamodel/submitReactionDataModel.dart';

class SubmitReactionProvider extends ChangeNotifier {
  SubmitReactionDataModel? _submitReactionDataModel;
  bool _isLoading = false;
  bool _isSubmitted = false;
  SubmitReactionDataModel? get submitReactionDataModel =>
      _submitReactionDataModel;
  bool get isLoading => _isLoading;
  bool get isSubmitted => _isSubmitted;

  Future<void> fetchSubmitReaction(int userid, int? reactingid,
      String reactiontype, String reactionfor) async {
    print('Fetching submitReaction for userId: $userid');
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> submitReactionResponse = await ApiController()
          .getSubmitReaction(userid, reactingid!, reactiontype, reactionfor);
      _submitReactionDataModel =
          SubmitReactionDataModel.fromJson(submitReactionResponse);
      if (_submitReactionDataModel!.errorCode == 200) {
        _isLoading = false;
        _isSubmitted = true;
        notifyListeners();
      } else {
        // Handle the case when the response has an error code other than 200
        print(
            'Failed to Submit for Review. Error code: ${_submitReactionDataModel!.errorCode}');
        _isLoading = false;
        notifyListeners();
        throw 'Failed to Submit for Review. Error code: ${_submitReactionDataModel!.errorCode}';
      }
    } catch (e) {
      // Handle the case when there is an exception during the API call
      _isLoading = false;
      notifyListeners();
      print('Failed to Submit for Review: $e');
      throw 'Failed to Submit for Review: $e';
    }
  }
}
