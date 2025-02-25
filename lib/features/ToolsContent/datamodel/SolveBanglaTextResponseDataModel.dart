class SolveBanglaTextResponseDataModel {
  final int? errorCode;
  final String? message;
  final String? answer;
  final String? question;

  SolveBanglaTextResponseDataModel({
    required this.errorCode,
    required this.message,
    required this.answer,
    required this.question,
  });

  factory SolveBanglaTextResponseDataModel.fromJson(Map<String, dynamic> json) {
    return SolveBanglaTextResponseDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      answer: json['answer'],
      question: json['question'],
    );
  }
}
