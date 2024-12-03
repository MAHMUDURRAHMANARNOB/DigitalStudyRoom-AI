import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../datamodel/toolsDataDataModel.dart';


class ToolsDataProvider extends ChangeNotifier {
  String _selectedClass = "";
  String _selectedSubject = "";

  String get selectedClass => _selectedClass;
  String get selectedSubject => _selectedSubject;

  set selectedClass(String value) {
    _selectedClass = value;
    notifyListeners();
  }

  set selectedSubject(String value) {
    _selectedSubject = value;
    notifyListeners();
  }

  ApiController _apiService = ApiController();
  ToolsData? _toolsData;
  ToolsData? get toolsData => _toolsData;

  Future<void> fetchToolsData(int userId, int toolsId) async {
    try {
      final response = await _apiService.getToolsData(userId, toolsId);
      _toolsData = ToolsData.fromJson(response);
      notifyListeners();
    } catch (e) {
      // Handle error, log, or show a message
      print("Error fetching tools data: $e");
    }
  }

  Future<void> fetchToolsDataByCode(int userId, String toolsCode) async {
    try {
      final response = await _apiService.getToolsDataByCode(userId, toolsCode);
      _toolsData = ToolsData.fromJson(response);
      notifyListeners();
    } catch (e) {
      // Handle error, log, or show a message
      print("Error fetching tools data: $e");
    }
  }
}
