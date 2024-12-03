class ToolsReplyDataModel {
  final int? errorCode;
  final String? message;
  final String? question;
  final String? answer;
  final int? commentId;

  ToolsReplyDataModel({
    required this.errorCode,
    required this.message,
    required this.question,
    required this.answer,
    required this.commentId,
  });

  factory ToolsReplyDataModel.fromJson(Map<String, dynamic> json) {
    return ToolsReplyDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      question: json['question'],
      answer: json['answer'],
      commentId: json['commentid'],
    );
  }
}
