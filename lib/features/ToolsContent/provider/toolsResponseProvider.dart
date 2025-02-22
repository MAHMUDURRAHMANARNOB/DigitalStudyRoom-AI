import 'dart:io';

import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../datamodel/toolsResponseDataModel.dart';


class ToolsResponseProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();

  ToolsResponseDataModel? _toolsResponse;

  ToolsResponseDataModel? get toolsResponse => _toolsResponse;

  Future<void> fetchToolsResponse(
      int userId,
      String questionText,
      String subject,
      String gradeClass,
      String toolsCode,
      String maxLine,
      String isMobile) async {
    print("inside fetchToolsResponse");
    try {
      final response = await _apiService.getToolsResponse(
        userId,
        questionText,
        subject,
        gradeClass,
        toolsCode,
        maxLine,
        isMobile,
      );
      print("Raw API Response: $response");
      if (response != null && response is Map<String, dynamic>) {
        _toolsResponse = ToolsResponseDataModel.fromJson(response);
        notifyListeners();
      } else {
        throw Exception("Invalid response format: Expected JSON object but got ${response.runtimeType}");
      }
    } catch (error) {
      print('Error in getToolsResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }

  Future<void> fetchImageToolsResponse(
      File questionImage,
      int userId,
      String questionText,
      String subject,
      String gradeClass,
      String toolsCode,
      String maxLine,
      String isMobile) async {
    print("inside fetchImageToolsResponse");
    try {
      final response = await _apiService.getImageToolsResponse(
        questionImage,
        userId,
        questionText,
        subject,
        gradeClass,
        toolsCode,
        maxLine,
        isMobile,
      );
      _toolsResponse = ToolsResponseDataModel.fromJson(response);

      print("Response from fetchImageToolsResponse: $response");
      notifyListeners();
    } catch (error) {
      print('Error in fetchImageToolsResponse: $error');
      throw Exception('$error');
    }
  }
}
