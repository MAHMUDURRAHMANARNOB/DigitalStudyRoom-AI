// course_model.dart
class GetCoursesDataModel {
  final String subjectName;
  final String coursePDFLink;

  GetCoursesDataModel({
    required this.subjectName,
    required this.coursePDFLink,
  });

  factory GetCoursesDataModel.fromJson(Map<String, dynamic> json) {
    return GetCoursesDataModel(
      subjectName: json['subjectName'] as String,
      coursePDFLink: json['CoursePDFLink'] as String,
    );
  }
}