import 'package:flutter/material.dart';

import '../../../api/api_controller.dart';
import '../datamodels/TutorChapterListDataModel.dart';

class TutorsChapterProvider with ChangeNotifier {
  List<Chapter>? _chapters;
  bool _isLoading = false;

  List<Chapter>? get chapters => _chapters;
  bool get isLoading => _isLoading;

  Future<void> fetchTutorsChapters(String classId, String subjectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiController.getTutorsChapters(classId, subjectId);
      if (response != null) {
        _chapters = response.chapterList;
      }
    } catch (e) {
      _chapters = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
