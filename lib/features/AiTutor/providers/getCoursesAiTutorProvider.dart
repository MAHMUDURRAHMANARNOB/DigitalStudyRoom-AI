import 'package:flutter/material.dart';
import '../../../api/api_controller.dart';
import '../datamodels/getCoursesDataModel.dart';

class GetCoursesAiTutorProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  List<GetCoursesDataModel> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<GetCoursesDataModel> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<List<GetCoursesDataModel>> fetchAiTutorCourses(String userId, String classId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _courses = await _apiController.getCoursesAiTutor(userId, classId);
      return _courses;
    } catch (e) {
      _error = e.toString();
      throw Exception('Error fetching courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}