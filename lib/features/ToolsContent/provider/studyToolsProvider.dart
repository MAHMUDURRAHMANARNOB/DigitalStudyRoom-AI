import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../datamodel/studyToolsDataModel.dart';

class StudyToolsProvider extends ChangeNotifier {
  List<StudyToolsDataModel> _tools = [];
  List<StudyToolsDataModel> get tools => _tools;

  Future<void> fetchTools(int userID) async {
    print('Fetching tools for userId: $userID');
    try {
      final tools = await ApiController.fetchTools(userID);
      if (tools.isEmpty) {
        if (kDebugMode) {
          print('⚠️ Warning: API returned an empty tools list!');
        }
      } else {
        if (kDebugMode) {
          print('✅ API returned ${tools.length} tools.');
        }
      }
      _tools = tools;
      notifyListeners();
      if (kDebugMode) {
        print('✅ Provider updated: tools count -> ${_tools.length}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Error fetching tools: $error');
      }
      throw Exception(
          'Failed to load study tools. Check your network connection.');
    }
  }
}
