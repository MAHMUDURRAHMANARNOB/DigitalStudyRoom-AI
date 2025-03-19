import 'dart:convert';

class TutorSuccessResponseDataModel {
  final int errorCode;
  final String message;
  final String? sessionId;
  final String? aiDialog;
  final String? aiDialogAudio;
  final String? lessonTitle;
  final String? chapterTitle;
  final int? lessonCount;
  final String? userText;
  final String? userAudioFile;
  final String? voiceText;

  TutorSuccessResponseDataModel({
    required this.errorCode,
    required this.message,
     this.sessionId,
     this.aiDialog,
     this.aiDialogAudio,
     this.lessonTitle,
     this.chapterTitle,
     this.lessonCount,
     this.userText,
     this.userAudioFile,
     this.voiceText,
  });

  factory TutorSuccessResponseDataModel.fromJson(Map<String, dynamic> json) {
    return TutorSuccessResponseDataModel(
      errorCode: json['errorcode'] ?? 0,
      message: json['message'] ?? '',
      sessionId: json['SessionID'] ?? '',
      aiDialog: json['AIDialoag'] ?? '',
      aiDialogAudio: json['AIDialoagAudio'] ?? '',
      lessonTitle: json['lessonTitle'] ?? '',
      chapterTitle: json['chapterTitle'] ?? '',
      lessonCount: json['lessoncount'] ?? 0,
      userText: json['userText'] ?? '',
      userAudioFile: json['userAudioFile'] ?? '',
      voiceText: json['voiceText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'SessionID': sessionId,
      'AIDialoag': aiDialog,
      'AIDialoagAudio': aiDialogAudio,
      'lessonTitle': lessonTitle,
      'chapterTitle': chapterTitle,
      'lessoncount': lessonCount,
      'userText': userText,
      'userAudioFile': userAudioFile,
      'voiceText': voiceText,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
