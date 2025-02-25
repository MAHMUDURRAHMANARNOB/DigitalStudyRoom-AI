import 'dart:io';

import 'package:flutter/material.dart';

import '../../../api/api_controller.dart';
import '../datamodel/SolveBanglaMathDataModel.dart';
import '../datamodel/SolveBanglaTextResponseDataModel.dart';

class SolveBanglaMathResponseProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();

  SolveBanglaTextResponseDataModel? _solveBanglaTextResponse;
  SolveBanglaMathDataModel? _solveBanglaMathDataModel;

  SolveBanglaTextResponseDataModel? get toolsResponse => _solveBanglaTextResponse;
  SolveBanglaMathDataModel? get solveBanglaMathDataModel =>
      _solveBanglaMathDataModel;

  Future<void> fetchMathSolutionResponse(
      int userId,
      String gradeClass,
      String problemText,
      ) async {
    // print("inside fetchToolsResponse");
    try {
      final response = await _apiService.getMathSolutionResponse(
        userId,
         gradeClass,
        problemText,
      );
      _solveBanglaTextResponse = SolveBanglaTextResponseDataModel.fromJson(response);
      print("Response from fetchToolsResponse: $response");
      notifyListeners();
    } catch (error) {
      print('Error in getToolsResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }

  Future<void> fetchMathImageSolutionResponse(
      File questionImage,
      int userId,
      String gradeClass,
      String questionText,
      ) async {
    print("inside fetchMathImageSolutionResponse");
    try {
      final response = await _apiService.getMathImageResponse(
        questionImage,
        userId,
        gradeClass,
        questionText,
      );
      _solveBanglaMathDataModel = SolveBanglaMathDataModel.fromJson(response);

      print("Response from fetchMathImageSolutionResponse: $response");
      notifyListeners();
    } catch (error) {
      print('Error in fetchMathImageSolutionResponse: $error');
      throw Exception('$error');
    }
  }
}
