import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../datamodel/studyToolsDataModel.dart';

class StudyToolsProvider extends ChangeNotifier {
  List<StudyToolsDataModel> _tools = [];
  int userId;
  StudyToolsProvider({required this.userId});

  List<StudyToolsDataModel> get tools => _tools;

  Future<void> fetchTools() async {
    print('Fetching tools for userId: $userId');
    try {
      final tools = await ApiController.fetchTools(userId);
      _tools = tools;
      notifyListeners();
    } catch (error) {
      print('Error fetching tools: $error');
      throw Exception(
          'Failed to load study tools. Check your network connection.');
    }
  }
}
