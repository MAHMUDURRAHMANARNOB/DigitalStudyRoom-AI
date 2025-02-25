class SolveBanglaMathDataModel {
  final int errorCode;
  final String message;
  final String? question;
  final String? answer;
  final String? ticketId;
  final String? remainingTicket;

  SolveBanglaMathDataModel({
    required this.errorCode,
    required this.message,
    this.question,
    this.answer,
    this.ticketId,
    this.remainingTicket,
  });

  // Factory constructor to parse JSON into SolveBanglaMathDataModel
  factory SolveBanglaMathDataModel.fromJson(Map<String, dynamic> json) {
    return SolveBanglaMathDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      question: json['question'],
      answer: json['answer'],
      ticketId: json['ticketid'],
      remainingTicket: json['remainingticket'],
    );
  }

  // Method to convert SolveBanglaMathDataModel object into JSON
  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'question': question,
      'answer': answer,
      'ticketid': ticketId,
      'remainingticket': remainingTicket,
    };
  }
}
