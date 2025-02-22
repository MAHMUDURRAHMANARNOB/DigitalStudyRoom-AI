import 'package:flutter/material.dart';

import '../../../api/api_controller.dart';
import '../datamodels/TutorDataModel.dart';

class TutorProvider extends ChangeNotifier {
  final ApiController apiController = ApiController();

  bool _isLoading = false;
  String? _errorMessage;
  List<Tutor> _tutors = [];
  int _errorCode = 0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Tutor> get tutors => _tutors;
  int get errorCode => _errorCode;

  Future<void> fetchTutors() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();
    // Do not notify listeners immediately here to avoid the issue during build phase

    try {
      final TutorResponse response = await apiController.getTutors();
      _errorCode = response.errorCode;

      if (_errorCode == 200) {
        _tutors = response.tutors;
      } else {
        _tutors = [];
        _errorMessage = response.message;
      }
    } catch (error) {
      _errorCode = 500;
      _tutors = [];
      _errorMessage = "Failed to load tutors. Please try again.";
    }

    _isLoading = false;

    // Use addPostFrameCallback to notify listeners after the current frame completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
