import 'package:flutter/material.dart';
import '../../../api/api_controller.dart';
import '../models/SelectClassDataModel.dart';

class ClassProvider with ChangeNotifier {
  List<Map<String, dynamic>> _classList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get classList => _classList;
  bool get isLoading => _isLoading;

  final ApiController _apiController = ApiController();

  Future<List<ClassModel>> loadClasses() async {
    try {
      return await _apiController.fetchClasses();
    } catch (e) {
      return [];
    }
  }
}
