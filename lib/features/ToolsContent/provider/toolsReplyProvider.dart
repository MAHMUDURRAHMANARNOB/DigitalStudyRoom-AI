import 'dart:io';

import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../datamodel/toolsReplyDataModel.dart';


class ToolsReplyProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();

  ToolsReplyDataModel? _toolsReply;

  ToolsReplyDataModel? get toolsResponse => _toolsReply;

  Future<void> fetchToolsReply(
      int userId, int ticketId, String questions, String isMobile) async {
    print("inside fetchToolsResponse");
    try {
      final response = await _apiService.getToolsReply(
        userId,
        ticketId,
        questions,
        isMobile,
      );
      _toolsReply = ToolsReplyDataModel.fromJson(response);
      print("Response from fetchToolsReply: $response");
      notifyListeners();
    } catch (error) {
      print('Error in fetchToolsReply: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
