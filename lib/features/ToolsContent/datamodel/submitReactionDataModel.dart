class SubmitReactionDataModel {
  final int errorCode;
  final String message;
  final int commentID;

  SubmitReactionDataModel(
      {required this.errorCode,
      required this.message,
      required this.commentID});

  factory SubmitReactionDataModel.fromJson(Map<String, dynamic> json) {
    return SubmitReactionDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      commentID: json['conemmentID'],
    );
  }
}
