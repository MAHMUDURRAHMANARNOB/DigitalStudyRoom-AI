class ToolsResponseDataModel {
  final int? errorCode;
  final String? message;
  final String? question;
  final String? answer;
  final int? ticketId;
  final int? remainingticket;

  ToolsResponseDataModel({
    required this.errorCode,
    required this.message,
    required this.question,
    required this.answer,
    required this.ticketId,
    required this.remainingticket,
  });

  factory ToolsResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ToolsResponseDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      question: json['question'],
      answer: json['answer'],
      ticketId: json['ticketid'],
      remainingticket: json['remainingticket'],
    );
  }
}
