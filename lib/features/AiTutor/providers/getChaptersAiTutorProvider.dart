// Provider
import 'package:flutter/material.dart';

import '../../../api/api_controller.dart';
import '../datamodels/getChaptersDataModel.dart';

class GetChaptersAiTutorProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  List<AiTutorChapter> _chapters = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AiTutorChapter> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChaptersAiTutor(String classId, String subjectId) async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();

    try {
      final response = await _apiController.getChaptersAiTutor(
        classId: classId,
        subjectId: subjectId,
      );
      _chapters = response.chapterList;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
