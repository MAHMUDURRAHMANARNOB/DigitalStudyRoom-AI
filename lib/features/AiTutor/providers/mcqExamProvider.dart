// Provider (providers/mcq_provider.dart)
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../api/api_controller.dart';
import '../datamodels/mcqDataModels.dart';

class McqProvider with ChangeNotifier {
  McqResponse? currentResponse;
  bool isLoading = false;
  String? errorMessage;
  bool showExplanation = false;
  MCQAnswer? selectedAnswer;
  File? selectedImage; // To store the selected image file

  Future<void> fetchQuestion(McqRequest request) async {
    isLoading = true;
    errorMessage = null;
    showExplanation = false;
    selectedAnswer = null;
    notifyListeners();

    try {
      final controller = ApiController();
      currentResponse = await controller.fetchMcqQuestion(
        McqRequest(
          userId: request.userId,
          courseId: request.courseId,
          chapterId: request.chapterId,
          pageId: request.pageId,
          isFullExam: request.isFullExam,
          questionId: request.questionId,
          ansId: request.ansId,
          pageImage: selectedImage, // Pass the selected image file
        ),
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void selectAnswer(MCQAnswer answer, McqRequest request) {
    selectedAnswer = answer;
    showExplanation = true;
    notifyListeners();

    if (answer.isCorrect == 'Y') {
      // Auto-proceed to next question after a delay
      Future.delayed(Duration(seconds: 2), () {
        fetchQuestion(McqRequest(
          userId: request.userId,
          courseId: request.courseId,
          chapterId: request.chapterId,
          pageId: request.pageId,
          isFullExam: request.isFullExam,
          questionId: currentResponse?.questionId.toString(),
          ansId: answer.id.toString(),
          pageImage: selectedImage, // Include image in subsequent requests if needed
        ));
      });
    }
  }

  void setImage(File? image) {
    selectedImage = image;
    notifyListeners();
  }

  void reset() {
    currentResponse = null;
    isLoading = false;
    errorMessage = null;
    showExplanation = false;
    selectedAnswer = null;
    selectedImage = null;
    notifyListeners();
  }
}