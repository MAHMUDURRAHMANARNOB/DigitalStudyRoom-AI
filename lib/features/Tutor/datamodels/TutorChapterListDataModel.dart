import 'dart:convert';

class ChapterListDataModel {
  final int errorCode;
  final String message;
  final List<Chapter>? chapterList;

  ChapterListDataModel({
    required this.errorCode,
    required this.message,
    this.chapterList,
  });

  factory ChapterListDataModel.fromJson(String source) =>
      ChapterListDataModel.fromMap(json.decode(source));

  factory ChapterListDataModel.fromMap(Map<String, dynamic> map) {
    return ChapterListDataModel(
      errorCode: map['errorcode'] ?? 0,
      message: map['message'] ?? '',
      chapterList: map['ChapterList'] != null
          ? List<Chapter>.from(map['ChapterList'].map((x) => Chapter.fromMap(x)))
          : null,
    );
  }
}

class Chapter {
  final int id;
  final String chapterName;

  Chapter({
    required this.id,
    required this.chapterName,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] ?? 0,
      chapterName: map['chapterName'] ?? '',
    );
  }
}
