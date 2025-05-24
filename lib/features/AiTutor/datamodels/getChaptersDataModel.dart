// Data Model
class AiTutorChapter {
  final int id;
  final String chapterName;
  final int chapStartPage;
  final int chapEndPage;

  AiTutorChapter({
    required this.id,
    required this.chapterName,
    required this.chapStartPage,
    required this.chapEndPage,
  });

  factory AiTutorChapter.fromJson(Map<String, dynamic> json) {
    return AiTutorChapter(
      id: json['id'] as int,
      chapterName: json['chapterName'] as String,
      chapStartPage: json['chapStartPage'] as int,
      chapEndPage: json['chapEndPage'] as int,
    );
  }
}

class GetAiTutorChapterResponseDataModel {
  final int errorCode;
  final String message;
  final List<AiTutorChapter> chapterList;

  GetAiTutorChapterResponseDataModel({
    required this.errorCode,
    required this.message,
    required this.chapterList,
  });

  factory GetAiTutorChapterResponseDataModel.fromJson(Map<String, dynamic> json) {
    var chapterList = json['ChapterList'] as List;
    List<AiTutorChapter> chapters = chapterList.map((i) => AiTutorChapter.fromJson(i)).toList();

    return GetAiTutorChapterResponseDataModel(
      errorCode: json['errorcode'] as int,
      message: json['message'] as String,
      chapterList: chapters,
    );
  }
}