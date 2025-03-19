import 'dart:convert';
import 'dart:io';
import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/foundation.dart';

import '../datamodels/TutorResponseDataModel.dart';

class TutorResponseProvider with ChangeNotifier {
  ApiController _apiService = ApiController();

  TutorSuccessResponseDataModel? _successResponse;

  // TutorNotSelectedResponse? _tutorNotSelectedResponse;
  bool _isLoading = false;

  TutorSuccessResponseDataModel? get successResponse => _successResponse;

  // TutorNotSelectedResponse? get tutorNotSelectedResponse =>
  //     _tutorNotSelectedResponse;

  bool get isLoading => _isLoading;

  Future<void> getTutorResponse(
    int userid,
    String userName,
    String nextLesson,
    String TutorId,
    String className,
    String SubjectName,
    String courseTopic,
    String? sessionId,
    File? audioFile,
    String? answerText,
    int? chapterId,
  ) async {
    _setLoading(true);

    try {
      Map<String, dynamic> response = await _apiService.getTutorResponse(
          userid,
          userName,
          nextLesson,
          TutorId,
          className,
          SubjectName,
          courseTopic,
          sessionId,
          audioFile,
          answerText,
          chapterId);

      // final data = json.decode(response.body);
      if (response['errorcode'] == 200) {
        // Parse success response
        _successResponse = TutorSuccessResponseDataModel.fromJson(response);
        // _tutorNotSelectedResponse = null; // Clear error response
      } else if (response['errorcode'] == 201) {
        // Parse error response
        // _tutorNotSelectedResponse = TutorNotSelectedResponse.fromJson(response);
        _successResponse = TutorSuccessResponseDataModel.fromJson(response); // Clear success response
      }else if (response['errorcode'] == 210) {
        // Parse error response
        // _tutorNotSelectedResponse = TutorNotSelectedResponse.fromJson(response);
        _successResponse = TutorSuccessResponseDataModel.fromJson(response); // Clear success response
      }
    } catch (error) {
      // Handle any errors here
      throw error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
