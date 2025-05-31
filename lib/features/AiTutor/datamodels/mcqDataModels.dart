// Data Models (models/mcq_models.dart)
import 'dart:io';

class McqRequest {
  final String userId;
  final String courseId;
  final String chapterId;
  final String pageId;
  final String isFullExam;
  final String? questionId;
  final String? ansId;
  final File? pageImage; // Changed to File type for image upload

  McqRequest({
    required this.userId,
    required this.courseId,
    required this.chapterId,
    required this.pageId,
    required this.isFullExam,
    this.questionId,
    this.ansId,
    this.pageImage,
  });

  Map<String, String> toFormData() {
    final map = {
      'userID': userId,
      'courseid': courseId,
      'chapterId': chapterId,
      'PageId': pageId,
      'isFullexam': isFullExam.toString(),
    };
    if (questionId != null) map['questionID'] = questionId!;
    if (ansId != null) map['ansID'] = ansId!;
    return map;
  }
}

class McqResponse {
  final int errorCode;
  final String message;
  final int? questionId;
  final String? question;
  final List<MCQAnswer>? answers;
  final String isExamCompleted;
  final int? totalAttended;
  final int? totalCorrect;
  final int? totalWrong;
  final int? totalSkip;

  McqResponse({
    required this.errorCode,
    required this.message,
    this.questionId,
    this.question,
    this.answers,
    required this.isExamCompleted,
    this.totalAttended,
    this.totalCorrect,
    this.totalWrong,
    this.totalSkip,
  });

  factory McqResponse.fromJson(Map<String, dynamic> json) {
    return McqResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      questionId: json['QuestionId'],
      question: json['Question'],
      answers: json['answer'] != null
          ? (json['answer'] as List).map((i) => MCQAnswer.fromJson(i)).toList()
          : null,
      isExamCompleted: json['isExamCompleted'],
      totalAttended: json['TotalAtteneded'],
      totalCorrect: json['TotalCorrect'],
      totalWrong: json['TotalWrong'],
      totalSkip: json['TotalSkip'],
    );
  }
}

class MCQAnswer {
  final int id;
  final String ansText;
  final String isCorrect;
  final String explanation;

  MCQAnswer({
    required this.id,
    required this.ansText,
    required this.isCorrect,
    required this.explanation,
  });

  factory MCQAnswer.fromJson(Map<String, dynamic> json) {
    return MCQAnswer(
      id: json['id'],
      ansText: json['ansText'],
      isCorrect: json['isCorrect'],
      explanation: json['explanation'],
    );
  }
}
